import UIKit

final class UserProfileViewController: BaseViewController, UserProfileViewInput {
    // MARK: - Properties
    private let userProfileView = UserProfileView()
    
    // MARK: - View events
    override func loadView() {
        super.loadView()
        
        view = userProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.drcBlue
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.drcSlate,
            NSFontAttributeName: UIFont.drcScreenNameFont() ?? UIFont.systemFont(ofSize: 17)
        ]
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(),
            for: .default
        )
    }
    
    // MARK: - UserProfileViewInput
    func setViewTitle(_ title: String) {
        self.title = title
    }
    
    private var onRightButtonTap: (() -> ())?
    func setRightButton(title: String, onTap: @escaping () -> ()) {
        onRightButtonTap = onTap
        
        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: title,
            style: .plain,
            target: self,
            action: #selector(onRightButtonTap(sender:)))
    }
    
    func setRightButtonEnabled(_ isEnabled: Bool) {
        navigationController?.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
    
    @objc private func onRightButtonTap(sender: UIControl) {
        onRightButtonTap?()
    }
    
    func setInputFieldsEnabled(_ isEnabled: Bool) {
        // TODO:
    }
    
    func setAvatarSelectionEnabled(_ isEnabled: Bool) {
        // TODO:
    }
    
    // MARK: ActivityDisplayable
    func startActivity() {
        userProfileView.startActivity()
    }
    
    func stopActivity() {
        userProfileView.stopActivity()
    }
}
