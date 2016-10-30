import UIKit

public extension UIEdgeInsets {
    
    func inverted() -> UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }
    
    var width: CGFloat {
        return left + right
    }
    
    var height: CGFloat {
        return top + bottom
    }
    
    var size: CGSize {
        return CGSize(width: width, height: height)
    }
}

public func ==(left: UIEdgeInsets, right: UIEdgeInsets) -> Bool {
    return UIEdgeInsetsEqualToEdgeInsets(left, right)
}

public func !=(left: UIEdgeInsets, right: UIEdgeInsets) -> Bool {
    return !UIEdgeInsetsEqualToEdgeInsets(left, right)
}

public func +(left: UIEdgeInsets, right: UIEdgeInsets) -> UIEdgeInsets {
    var insets = left
    insets.top += right.top
    insets.bottom += right.bottom
    insets.left += right.left
    insets.right += right.right
    return insets
}

public func -(left: UIEdgeInsets, right: UIEdgeInsets) -> UIEdgeInsets {
    var insets = left
    insets.top -= right.top
    insets.bottom -= right.bottom
    insets.left -= right.left
    insets.right -= right.right
    return insets
}
