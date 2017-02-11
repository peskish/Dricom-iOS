import UIKit

public struct ContentFittingRect {
    public var rect: CGRect
    
    // Convenient function
    public func fits(height: CGFloat) -> Bool {
        return rect.size.height <= height
    }
    
    public init(rectRelativeToWindow: CGRect) {
        rect = rectRelativeToWindow
    }
    
    public init(boundsOfView view: UIView) {
        self.init(bounds: view.bounds, ofView: view)
    }
    
    // You may pass, for example, extended bounds of view.
    // View argument will be used to convert rect.
    public init(bounds: CGRect, ofView view: UIView) {
        rect = view.convert(bounds, to: nil)
    }
    
    public init?(contentOfScrollView scrollView: UIScrollView) {
        let frame = CGRect(
            origin: CGPoint(
                x: -scrollView.contentOffset.x,
                y: -scrollView.contentOffset.y
            ),
            size: scrollView.contentSize
        )
        
        let rectRelativeToWindow = scrollView.superview?.convert(frame, to: nil)
        
        if let rectRelativeToWindow = rectRelativeToWindow {
            self.init(rectRelativeToWindow: rectRelativeToWindow)
        } else {
            return nil
        }
    }
}
