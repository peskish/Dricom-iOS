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
                NSFontAttributeName: UIFont.drcScreenNameFont() ?? UIFont.systemFont(ofSize: 17)
            ]
            
            if let backgroundImage = UIImage.imageWithColor(UIColor.drcWhite) {
                navigationBar.setBackgroundImage(
                    backgroundImage,
                    for: .default
                )
            }
        }
    }
}
