import UIKit

struct CombinedKeyboardAvoidingSettings {
    var contentFittingFunction: ContentFittingFunction
    var rectForContent: ContentFittingRect?
    var observable: CombinedKeyboardAvoidingSettingsObservable
}

final class CombinedKeyboardAvoidingSettingsObservable {
    var onChange: (() -> ())?
}

enum FirstResponderSettingsFindingOptions {
    case returnSettingsOfCurrentView
    case continueFindingInSuperviews
}

public final class FirstResponderSettingsManager {
    private let firstResponderSettings: FirstResponderSettings
    
    init(firstResponderSettings: FirstResponderSettings) {
        self.firstResponderSettings = firstResponderSettings
    }
    
    public convenience init?(view: UIView?) {
        self.init(view: view, options: .continueFindingInSuperviews)
    }
    
    convenience init?(view: UIView?, options: FirstResponderSettingsFindingOptions) {
        guard let view = view else { return nil }
        
        let firstResponderSettings = FirstResponderSettingsManager.findFirstResponderSettings(
            view: view,
            options: options
        )
        
        if let firstResponderSettings = firstResponderSettings {
            self.init(firstResponderSettings: firstResponderSettings)
        } else {
            return nil
        }
    }
    
    static func findFirstResponderSettings(view: UIView, options: FirstResponderSettingsFindingOptions) -> FirstResponderSettings? {
        if let firstResponderSettings = view.firstResponderSettings() {
            return firstResponderSettings
        } else {
            switch options {
            case .returnSettingsOfCurrentView:
                return nil
            case .continueFindingInSuperviews:
                if let superview = view.superview {
                    return findFirstResponderSettings(
                        view: superview,
                        options: options
                    )
                } else {
                    return nil
                }
            }
        }
    }
    
    public func findTextInputResponsible() -> UIView? {
        if let textInputResponsible = firstResponderSettings.textInputResponsible {
            return textInputResponsible
        } else {
            for subview in firstResponderSettings.owner.subviews {
                if let submanager = FirstResponderSettingsManager(view: subview, options: .returnSettingsOfCurrentView) {
                    if let textInputResponsible = submanager.findTextInputResponsible() {
                        return textInputResponsible
                    }
                }
            }
            // Not found
            return nil
        }
    }
    
    func combinedKeyboardAvoidingSettings() -> CombinedKeyboardAvoidingSettings? {
        let settingsPath = keyboardAvoidingSettingsPath()
        
        if let deepestSubviewSettings = settingsPath.first {
            let combinedKeyboardAvoidingSettingsObservable = CombinedKeyboardAvoidingSettingsObservable()
            
            for settings in settingsPath {
                settings.observable.onChange = {
                    combinedKeyboardAvoidingSettingsObservable.onChange?()
                }
            }
            
            let otherSettings = settingsPath.dropFirst()
            
            let contentFittingFunction = otherSettings.reduce(deepestSubviewSettings.contentFittingFunction) { (combinedFunction: ContentFittingFunction, keyboardAvoidingSettings: KeyboardAvoidingSettings) -> ContentFittingFunction in
                let combineFunction = keyboardAvoidingSettings.contentFittingCombineFunction.function
                let currentFunction = keyboardAvoidingSettings.contentFittingFunction
                let subviewFunction = combinedFunction
                return combineFunction(
                    currentFunction,
                    subviewFunction
                )
            }
            
            var rectForContent: ContentFittingRect?
            for settings in settingsPath.reversed() {
                if let settingsRectForContent = settings.rectForContent {
                    rectForContent = settingsRectForContent
                    break
                }
            }
            
            return CombinedKeyboardAvoidingSettings(
                contentFittingFunction: contentFittingFunction,
                rectForContent: rectForContent,
                observable: combinedKeyboardAvoidingSettingsObservable
            )
        } else {
            return nil
        }
    }
    
    // From subviews to superviews
    func keyboardAvoidingSettingsPath() -> [KeyboardAvoidingSettings] {
        return keyboardAvoidingSettingsPathFromSubviewSettings(firstResponderSettings)
    }
    
    func keyboardAvoidingSettingsPathFromSubviewSettings(_ firstResponderSettings: FirstResponderSettings) -> [KeyboardAvoidingSettings] {
        let path = firstResponderSettings.keyboardAvoidingSettings.flatMap { [$0] } ?? []
        
        if let superview = firstResponderSettings.owner.superview {
            let superSettings = FirstResponderSettingsManager.findFirstResponderSettings(
                view: superview,
                options: .continueFindingInSuperviews
            )
            if let superSettings = superSettings {
                let superPath = keyboardAvoidingSettingsPathFromSubviewSettings(superSettings)
                
                return path + superPath
            } else {
                return path
            }
        } else {
            return path
        }
    }
}
