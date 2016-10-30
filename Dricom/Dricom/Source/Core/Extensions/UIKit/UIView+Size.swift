import UIKit

public extension UIView {
    
    final func heightForWidth(_ width: CGFloat) -> CGFloat {
        return sizeForWidth(width).height
    }
    
    final func widthForHeight(_ height: CGFloat) -> CGFloat {
        return sizeForWidth(height).width
    }
    
    final func sizeForWidth(_ width: CGFloat) -> CGSize {
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        return sizeThatFits(maxSize).intersectionWidth(width)
    }
    
    final func sizeForHeight(_ height: CGFloat) -> CGSize {
        let maxSize = CGSize(width: .greatestFiniteMagnitude, height: height)
        return sizeThatFits(maxSize).intersectionHeight(height)
    }
    
    final func sizeThatFits() -> CGSize {
        // Returns same size as view gets after sizeToFit(): desired size without restrictions
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude))
    }
}
    
