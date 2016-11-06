import UIKit

extension UIView {
    static func findFirstResponderIn(view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }
        for subview in view.subviews {
            if let firstResponder = self.findFirstResponderIn(view: subview) {
                return firstResponder
            }
        }
        return nil
    }
}
