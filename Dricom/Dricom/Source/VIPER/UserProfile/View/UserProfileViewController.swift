import UIKit

final class UserProfileViewController: BaseViewController, UserProfileViewInput, InputFieldsContainerHolder {
    // MARK: - Properties
    private let userProfileView = UserProfileView()
    
    // MARK: - View events
    override func loadView() {
        view = userProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navBar = navigationController?.navigationBar else { return }
        
        navBar.shadowImage = UIImage()
        navBar.tintColor = UIColor.drcBlue
        navBar.isTranslucent = false
        navBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.drcSlate,
            NSFontAttributeName: UIFont.drcScreenNameFont() ?? UIFont.systemFont(ofSize: 17)
        ]
        navBar.setBackgroundImage(
            UIImage(),
            for: .default
        )
    }
    
    // MARK: - UserProfileViewInput
    func setUserInteractionEnabled(_ isEnabled: Bool) {
        view.isUserInteractionEnabled = isEnabled
        navigationController?.navigationBar.isUserInteractionEnabled = isEnabled
        navigationController?.view.isUserInteractionEnabled = isEnabled
    }
    
    func setViewTitle(_ title: String) {
        self.title = title
    }
    
    func setCancelButtonTitle(_ title: String) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: title,
            style: .plain,
            target: self,
            action: #selector(onCancelButtonTap(_:))
        )
    }
    
    var onCancelButtonTap: (() -> ())?
    @objc private func onCancelButtonTap(_ sender: UIBarButtonItem) {
        onCancelButtonTap?()
    }
    
    private var onRightButtonTap: (() -> ())?
    func setRightButton(title: String, onTap: @escaping () -> ()) {
        onRightButtonTap = onTap
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: title,
            style: .plain,
            target: self,
            action: #selector(onRightButtonTap(sender:)))
    }
    
    func setRightButtonEnabled(_ isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
    
    @objc private func onRightButtonTap(sender: UIControl) {
        onRightButtonTap?()
    }
    
    func setInputFieldsEnabled(_ isEnabled: Bool) {
        userProfileView.setInputFieldsEnabled(isEnabled)
    }
    
    func setAvatarSelectionEnabled(_ isEnabled: Bool) {
        userProfileView.setAvatarSelectionEnabled(isEnabled)
    }
    
    var onChangePhotoButtonTap: (() -> ())? {
        get { return userProfileView.onChangePhotoButtonTap }
        set { userProfileView.onChangePhotoButtonTap = newValue }
    }
    
    func setAvatarPhotoImage(_ image: UIImage?) {
        userProfileView.setAvatarPhotoImage(image)
    }
    
    func setAvatarImageUrl(_ avatarImageUrl: URL?) {
        userProfileView.setAvatarImageUrl(avatarImageUrl)
    }
    
    func setAddPhotoTitle(_ title: String) {
        userProfileView.setAddPhotoTitle(title)
    }
    
    func setAddPhotoTitleVisible(_ isVisible: Bool) {
        userProfileView.setAddPhotoTitleVisible(isVisible)
    }
    
    func endEditing() {
        userProfileView.endEditing(true)
    }
    
    // MARK: ActivityDisplayable
    func startActivity() {
        userProfileView.startActivity()
        setUserInteractionEnabled(false)
    }
    
    func stopActivity() {
        userProfileView.stopActivity()
        setUserInteractionEnabled(true)
    }
    
    // MARK: InputFieldsContainerHolder
    var inputFieldsContainer: InputFieldsContainer {
        return userProfileView
    }
}
