import UIKit

final class SpecFonts {
    static func rubicMedium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func rubicRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
