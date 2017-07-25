import UIKit

enum NavBarStyle {
    case main
}

extension UINavigationController {
    func setStyle(_ style: NavBarStyle) {
        switch style {
        case .main:
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = false
            navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName: UIColor.drcSlate,
                NSFontAttributeName: SpecFonts.ralewayBold(16)
            ]
            navigationBar.tintColor = UIColor.drcBlue
            
            if let backgroundImage = UIImage.imageWithColor(UIColor.drcWhite) {
                navigationBar.setBackgroundImage(
                    backgroundImage,
                    for: .default
                )
            }
        }
    }
}
