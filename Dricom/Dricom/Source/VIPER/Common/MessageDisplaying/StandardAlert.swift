import UIKit

private struct LastPresentedAlert {
    weak var alert: UIAlertController?
    var cancelAction: (() -> ())?
    
    init(alert: UIAlertController,
         cancelAction: (() -> ())?)
    {
        self.alert = alert
        self.cancelAction = cancelAction
    }
}

final class StandardAlert {
    enum `Type` {
        case alert
        case actionSheet
        
        func toUIAlertControllerStyle() -> UIAlertControllerStyle {
            switch self {
            case .alert:
                return .alert
            case .actionSheet:
                return .actionSheet
            }
        }
    }
    
    var buttons: [Button] = []
    var cancelButton: Button?
    var destructiveButton: Button?
    var message: String?
    var title: String?
    var completion: (() -> ())?
    var type: Type
    
    private static var lastPresentedAlert: LastPresentedAlert?
    
    // MARK: Init
    init(type: Type = .alert) {
        self.type = type
    }
    
    convenience init(title: String? = nil, message: String?, cancelButton: Button = Button("OK", type: .cancel)) {
        self.init()
        
        self.title = title
        self.message = message
        self.cancelButton = cancelButton
    }
    
    // MARK: Convenience methods
    func addButton(_ button: Button) {
        buttons.append(button)
    }
    
    // MARK: - Button -
    class Button: Hashable {
        init(_ title: String, type: ButtonType = .custom, completion: (() -> ())? = nil) {
            self.type = type
            self.title = title
            self.completion = completion
        }
        
        let title: String?
        let type: ButtonType
        var completion: (() -> ())?
        let hashValue = Int.random()
    }
    
    enum ButtonType {
        case cancel
        case destructive
        case custom
        
        func toAlertActionStyle() -> UIAlertActionStyle {
            switch self {
            case .cancel:
                return .cancel
            case .destructive:
                return .destructive
            case .custom:
                return .default
            }
        }
    }
    
    // MARK: - Presentation
    func showInViewController(_ viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: type.toUIAlertControllerStyle())
        
        alertController.view.tintColor = UIColor.drcSlate
        
        let alertCancelAction: (() -> ())?
        
        if let cancelButton = cancelButton {
            alertCancelAction = { [completion] in
                cancelButton.completion?()
                completion?()
            }
            
            let cancelAction = UIAlertAction(title: cancelButton.title, style: .cancel) { _ in
                alertCancelAction?()
            }
            
            alertController.addAction(cancelAction)
        } else {
            alertCancelAction = completion
        }
        
        if let destructiveButton = destructiveButton {
            let destructiveAction = UIAlertAction(title: destructiveButton.title, style: .destructive) { [completion] _ in
                destructiveButton.completion?()
                completion?()
            }
            alertController.addAction(destructiveAction)
        }
        
        for button in buttons {
            let action = UIAlertAction(title: button.title, style: button.type.toAlertActionStyle()) { [completion] _ in
                button.completion?()
                completion?()
            }
            alertController.addAction(action)
        }
        
        StandardAlert.dismissAlertAnimated(false)
        
        if let popover = alertController.popoverPresentationController, let view = viewController.view {
            let sourceRect = CGRect(
                x: view.bounds.centerX,
                y: view.bounds.centerY - 100,
                width: 1,
                height: 1
            )

            popover.sourceView = view
            popover.sourceRect = sourceRect
            popover.permittedArrowDirections = .init(rawValue: 0)
        }
        
        viewController.present(alertController, animated: true, completion: nil)
        
        StandardAlert.lastPresentedAlert = LastPresentedAlert(alert: alertController, cancelAction: alertCancelAction)
    }
    
    // MARK: - Dismissal
    static func dismissAlertAnimated(_ animated: Bool) {
        if let lastPresentedAlert = lastPresentedAlert, let alert = lastPresentedAlert.alert {
            // Dismiss an alert as if `cancel` button was tapped
            alert.dismiss(animated: animated, completion: nil)
            lastPresentedAlert.cancelAction?()
        }
        StandardAlert.lastPresentedAlert = nil
    }
}

func ==(pattern: StandardAlert.Button, value: StandardAlert.Button) -> Bool {
    return pattern === value
}

func ~=(pattern: StandardAlert.Button, value: StandardAlert.Button) -> Bool {
    return pattern === value
}
