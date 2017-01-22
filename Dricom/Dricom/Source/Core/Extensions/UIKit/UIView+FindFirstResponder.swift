import UIKit

public extension UIView {
    
    private struct AssociatedKeys {
        static var CurrentFirstResponder = "nsh_CurrentFirstResponder"
    }
    
    private class var currentFirstResponder: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.CurrentFirstResponder) as? UIView
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.CurrentFirstResponder,
                    newValue,
                    .OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }
    
    public class func findFirstResponderView(_ view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }
        for subview in view.subviews {
            let firstResponder = findFirstResponderView(subview)
            if let firstResponder = firstResponder {
                return firstResponder
            }
        }
        return nil
    }
    
    // It looks a bit kludgy, but it's recommended solution to find first responder (and the most proper)
    public func firstResponderFindingAction(_ sender: AnyObject?) {
        UIView.currentFirstResponder = self
    }
    
    public class func findFirstResponderViewInApplication() -> UIView? {
        currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIView.firstResponderFindingAction(_:)), to: nil, from: nil, for: nil)
        if let currentFirstResponder = currentFirstResponder {
            return currentFirstResponder
        }
        return nil
    }
    
}
