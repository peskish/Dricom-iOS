import UIKit

public extension CGRect {
    // Basic properties:
    
    var x: CGFloat {
        get { return origin.x }
        set { origin.x = newValue }
    }
    var y: CGFloat {
        get { return origin.y }
        set { origin.y = newValue }
    }
    
    // Basic alignment:
    
    var center: CGPoint {
        get {
            return CGPoint(x: centerX, y: centerY)
        }
        set {
            centerX = newValue.x
            centerY = newValue.y
        }
    }
    
    var centerX: CGFloat {
        get { return x + width/2 }
        set { x = newValue - width/2 }
    }
    var centerY: CGFloat {
        get { return y + height/2 }
        set { y = newValue - height/2 }
    }
    var left: CGFloat {
        get { return x }
        set { x = newValue }
    }
    var right: CGFloat {
        get { return left + width }
        set { left = newValue - width }
    }
    var top: CGFloat {
        get { return y }
        set { y = newValue }
    }
    var bottom: CGFloat {
        get { return top + height }
        set { top = newValue - height }
    }
    
    init(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        self.init(x: left, y: top, width: right - left, height: bottom - top)
    }
    
    init(left: CGFloat, right: CGFloat, top: CGFloat, height: CGFloat) {
        self.init(x: left, y: top, width: right - left, height: height)
    }
    
    init(left: CGFloat, right: CGFloat, bottom: CGFloat, height: CGFloat) {
        self.init(x: left, y: bottom - height, width: right - left, height: height)
    }
    
    init(left: CGFloat, right: CGFloat, centerY: CGFloat, height: CGFloat) {
        self.init(x: left, y: centerY - height/2, width: right - left, height: height)
    }
    
    // MARK: - Insets
    
    func shrinked(_ insets: UIEdgeInsets) -> CGRect {
        return UIEdgeInsetsInsetRect(self, insets)
    }
    func shrinked(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> CGRect {
        return UIEdgeInsetsInsetRect(self, UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
    }
    func extended(_ insets: UIEdgeInsets) -> CGRect {
        return shrinked(insets.inverted())
    }
    func extended(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> CGRect {
        return shrinked(UIEdgeInsets(top: top, left: left, bottom: bottom, right: right).inverted())
    }
    
    // MARK: -
    
    func inverted() -> CGRect {
        return CGRect(left: right, right: left, top: bottom, bottom: top)
    }
    
    func intersectionOrNil(_ other: CGRect) -> CGRect? {
        let cgIntersection = self.intersection(other)
        if cgIntersection == CGRect.null {
            return nil
        } else {
            return cgIntersection
        }
    }
    
    // Return insets needed to shrink self to other.
    // A.shrinked(A.insetsToShrinkToRect(B)) == B
    func insetsToShrinkToRect(_ other: CGRect) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: other.top - top,
            left: other.left - left,
            bottom: bottom - other.bottom,
            right: right - other.right
        )
    }
    
    // Gets intersection with other rect, and cuts it off
    func cutTop(_ other: CGRect) -> CGRect {
        if let intersection = self.intersectionOrNil(other) {
            return CGRect(left: left, right: right, top: intersection.bottom, bottom: bottom)
        } else {
            return self // nothing to cut
        }
    }
    
    func cutBottom(_ other: CGRect) -> CGRect {
        if let intersection = self.intersectionOrNil(other) {
            return CGRect(left: left, right: right, top: top, bottom: intersection.top)
        } else {
            return self // nothing to cut
        }
    }
    
    func cutLeft(_ other: CGRect) -> CGRect {
        if let intersection = self.intersectionOrNil(other) {
            return CGRect(left: intersection.right, right: right, top: top, bottom: bottom)
        } else {
            return self // nothing to cut
        }
    }
    
    func cutRight(_ other: CGRect) -> CGRect {
        if let intersection = self.intersectionOrNil(other) {
            return CGRect(left: left, right: intersection.left, top: top, bottom: bottom)
        } else {
            return self // nothing to cut
        }
    }
    
    // Note: right will not be changed! (so it will change width)
    func byChangingLeft(_ left: CGFloat) -> CGRect {
        return CGRect(left: left, right: right, top: top, bottom: bottom)
    }
    
    // Note: left will not be changed
    func byChangingRight(_ right: CGFloat) -> CGRect {
        return CGRect(left: left, right: right, top: top, bottom: bottom)
    }
    
    // Note: bottom will not be changed
    func byChangingTop(_ top: CGFloat) -> CGRect {
        return CGRect(left: left, right: right, top: top, bottom: bottom)
    }
    
    // Note: top will not be changed
    func byChangingBottom(_ bottom: CGFloat) -> CGRect {
        return CGRect(left: left, right: right, top: top, bottom: bottom)
    }
    
    func byChangingBottomAndHeight(_ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func byChangingRightAndWidth(_ width: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func byChangingBottom(newBottom: CGFloat, resizeStrategy: ResizeStrategy) -> CGRect {
        switch resizeStrategy {
        case .changeSize:
            return CGRect(left: left, right: right, top: top, bottom: newBottom)
        case .keepSize:
            return CGRect(left: left, right: right, bottom: newBottom, height: height)
        }
    }
    
    func byChangingRight(newRight: CGFloat, resizeStrategy: ResizeStrategy) -> CGRect {
        switch resizeStrategy {
        case .keepSize:
            return CGRect(x: newRight - width, y: y, width: width, height: height)
        case .changeSize:
            return CGRect(left: left, right: newRight, top: top, bottom: bottom)
        }
    }
    
    enum ResizeStrategy {
        case keepSize
        case changeSize
    }
    
    func byChangingSize(_ size: CGSize) -> CGRect {
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}
