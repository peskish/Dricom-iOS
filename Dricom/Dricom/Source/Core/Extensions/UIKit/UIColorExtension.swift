import UIKit

public extension UIColor {
    
    // MARK: RGB
    static func RGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static func RGBS(rgb: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: rgb/255, green: rgb/255, blue: rgb/255, alpha: alpha)
    }
    
    static func white(_ white: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(white: white/255, alpha: alpha)
    }
    
    // MARK: HEX
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
