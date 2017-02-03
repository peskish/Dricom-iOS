import UIKit

public extension UIViewController {

    var defaultContentInsets: UIEdgeInsets {
        return UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)
    }
    
    func setNavigationBarShadowHidden(_ hidden: Bool) {
        let image: UIImage? = hidden ? UIImage() : nil
        navigationController?.navigationBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        
        // AI-2889
        if UIDevice.iosVersion.majorVersion < 9 {
            showNavigationBarBottomLine()
        }
    }
    
    func showNavigationBarBottomLine() {
        guard let subviews = self.navigationController?.navigationBar.subviews else {
            return
        }
        
        func processView(_ view: UIView) -> Bool {
            if view is UIImageView && view.height <= 1.0 && view.alpha == 0 {
                view.alpha = 1
                return true
            }
            return false
        }
        
        for parentView in subviews {
            for view in parentView.subviews {
                if processView(view) {
                    break
                }
            }
        }
    }
}
