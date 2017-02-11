import UIKit

// Why it is an NSObject?
//
// Overriding methods and properties in an extension works
// with the current Swift only for Objective-C compatible methods and properties.
//
// But the main idea is to override a function (see below) in containers of first responder.

open class FirstResponderSettings: NSObject {
    open let keyboardAvoidingSettings: KeyboardAvoidingSettings?
    open let owner: UIView
    open let textInputResponsible: UIView?
    
    public init(keyboardAvoidingSettings: KeyboardAvoidingSettings?, owner: UIView, textInputResponsible: UIView?) {
        self.keyboardAvoidingSettings = keyboardAvoidingSettings
        self.owner = owner
        self.textInputResponsible = textInputResponsible
        
        super.init()
    }
}

extension UIView: FirstResponderSettingsProvider {
    open func firstResponderSettings() -> FirstResponderSettings? {
        return nil
    }
}

@objc public protocol FirstResponderSettingsProvider {
    func firstResponderSettings() -> FirstResponderSettings?
}
