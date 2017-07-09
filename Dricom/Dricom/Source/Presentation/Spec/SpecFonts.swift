import UIKit

final class SpecFonts {
    static func rubicMedium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func rubicRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Rubik-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func ralewayBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Raleway-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func ralewayMedium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Raleway-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func ralewayRegular(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Raleway-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func ralewaySemiBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Raleway-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
