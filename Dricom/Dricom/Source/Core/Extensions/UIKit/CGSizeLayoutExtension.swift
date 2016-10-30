import UIKit

public extension CGSize {
    
    // MARK: - Sizes
    
    static let minimumTapAreaSize = CGSize(width: 44, height: 44)
    
    // MARK: - Insets
    
    // Shrink size with insets, resulting size will be smaller
    func shrinked(_ insets: UIEdgeInsets) -> CGSize {
        return CGSize(
            width: width - insets.width,
            height: height - insets.height
        )
    }
    
    // Extend size with insets, resulting size will be bigger
    func extended(_ insets: UIEdgeInsets) -> CGSize {
        return shrinked(insets.inverted())
    }
    
    // MARK: - Intersection
    
    // Intersect two sizes (imagine intersection between two rectangles with x = width, y = height)
    // Resulting size will be smaller than self and other or equal
    func intersection(_ other: CGSize) -> CGSize {
        return CGSize(
            width: min(width, other.width),
            height: min(height, other.height)
        )
    }
    
    func intersectionHeight(_ height: CGFloat) -> CGSize {
        return CGSize(
            width: width,
            height: min(self.height, height)
        )
    }
    
    func intersectionWidth(_ width: CGFloat) -> CGSize {
        return CGSize(
            width: min(self.width, width),
            height: height
        )
    }
    
    func intersectionHeight(_ other: CGSize) -> CGSize {
        return intersectionHeight(other.height)
    }
    
    func intersectionWidth(_ other: CGSize) -> CGSize {
        return intersectionWidth(other.width)
    }
    
    // MARK: - Union
    
    // Resulting size will be bigger than self and other or equal
    func union(_ other: CGSize) -> CGSize {
        return CGSize(
            width: max(width, other.width),
            height: max(height, other.height)
        )
    }
    
    func unionWidth(_ width: CGFloat) -> CGSize {
        return CGSize(
            width: max(self.width, width),
            height: height
        )
    }
    
    func unionHeight(_ height: CGFloat) -> CGSize {
        return CGSize(
            width: width,
            height: max(self.height, height)
        )
    }
    
    func unionWidth(_ other: CGSize) -> CGSize {
        return unionWidth(other.width)
    }
    
    func unionHeight(_ other: CGSize) -> CGSize {
        return unionHeight(other.height)
    }
    
    // MARK: - Substraction
    
    // Substract components of CGSize (width and height)
    func minus(_ other: CGSize) -> CGSize {
        return CGSize(width: width - other.width, height: height - other.height)
    }
    
    func minusHeight(_ height: CGFloat) -> CGSize {
        return CGSize(width: width, height: self.height - height)
    }
    
    func minusWidth(_ width: CGFloat) -> CGSize {
        return CGSize(width: self.width - width, height: height)
    }
    
    func minusHeight(_ other: CGSize) -> CGSize {
        return minusHeight(other.height)
    }
    
    func minusWidth(_ other: CGSize) -> CGSize {
        return minusWidth(other.width)
    }
    
    // MARK: - Multiplication
    
    func multiply(_ factor: CGFloat) -> CGSize {
        return CGSize(width: width * factor, height: height * factor)
    }
    
    // MARK: - Addition
    
    // Sum components of CGSize (width and height)
    func plus(_ other: CGSize) -> CGSize {
        return CGSize(
            width: width + other.width,
            height: height + other.height
        )
    }
    
    func plusHeight(_ height: CGFloat) -> CGSize {
        return CGSize(
            width: width,
            height: self.height + height
        )
    }
    
    func plusWidth(_ width: CGFloat) -> CGSize {
        return CGSize(
            width: self.width + width,
            height: height
        )
    }
    
    func plusHeight(_ other: CGSize) -> CGSize {
        return plusHeight(other.height)
    }
    
    func plusWidth(_ other: CGSize) -> CGSize {
        return plusWidth(other.width)
    }
    
    // MARK: - Rounding
    
    func ceil() -> CGSize {
        return CGSize(
            width: CoreGraphics.ceil(width),
            height: CoreGraphics.ceil(height)
        )
    }
    
    func floor() -> CGSize {
        return CGSize(
            width: CoreGraphics.floor(width),
            height: CoreGraphics.floor(height)
        )
    }
}

public func +(left: CGSize, right: CGSize) -> CGSize {
    return CGSize(
        width: left.width + right.width,
        height: left.height + right.height
    )
}

public func -(left: CGSize, right: CGSize) -> CGSize {
    return CGSize(
        width: left.width - right.width,
        height: left.height - right.height
    )
}

public func *(left: CGFloat, right: CGSize) -> CGSize {
    return CGSize(
        width: left * right.width,
        height: left * right.height
    )
}

public func *(left: CGSize, right: CGFloat) -> CGSize {
    return right * left
}

public func /(left: CGSize, right: CGFloat) -> CGSize {
    return CGSize(
        width: left.width / right,
        height: left.height / right
    )
}
