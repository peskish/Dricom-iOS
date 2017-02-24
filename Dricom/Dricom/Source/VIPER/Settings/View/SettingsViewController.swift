import UIKit

final class SettingsViewController: BaseViewController, SettingsViewInput {
    // MARK: - Properties
    private let settingsView = SettingsView()
    
    // MARK: - View events
    override func loadView() {
        super.loadView()
        
        view = settingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.drcSlate,
            NSFontAttributeName: UIFont.drcScreenNameFont() ?? UIFont.systemFont(ofSize: 17)
        ]
        
        if let backgroundImage = UIImage.imageWithColor(UIColor.drcWhite) {
            navigationController?.navigationBar.setBackgroundImage(
                backgroundImage,
                for: .default
            )
        }
    }
    
    // MARK: - SettingsViewInput
    func setViewTitle(_ title: String) {
        self.title = title
    }
}
