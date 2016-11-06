import UIKit

class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        setupStyle()
    }
    
    // MARK: Styling
    private func setupStyle() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = .clear
        navigationBar.tintColor = .white
    }
}
