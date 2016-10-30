import UIKit

public protocol ResizingView: class {
    func invalidateContentSize()
    func subviewDidInvalidateContentSize(_ subview: UIView)
    func resizeToFitSize(_ size: CGSize)
    func resizeToFitWidth(_ width: CGFloat)
    func resizeToFitHeight(_ height: CGFloat)
}

extension UIView: ResizingView {
    // MARK: - Resize
    final public func resizeToFitSize(_ size: CGSize) {
        self.size = sizeThatFits(size).intersection(size)
    }
    
    final public func resizeToFitWidth(_ width: CGFloat) {
        resizeToFitSize(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }
    
    final public func resizeToFitHeight(_ height: CGFloat) {
        resizeToFitSize(CGSize(width: CGFloat.greatestFiniteMagnitude, height: height))
    }
    
    // MARK: - Autoresize
    open func subviewDidInvalidateContentSize(_ subview: UIView) {
        // Problem: to disable further callbacks to superviews you don't call `super.subviewDidInvalidateContentSize`,
        // but there may be logic in superclass in this method. TODO: make calling super possible and not harmful.
        superview?.subviewDidInvalidateContentSize(self)
    }
    
    open func invalidateContentSize() {
        superview?.subviewDidInvalidateContentSize(self)
    }
}
