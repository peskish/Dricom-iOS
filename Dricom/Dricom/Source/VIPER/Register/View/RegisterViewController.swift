import UIKit

final class RegisterViewController: BaseViewController, RegisterViewInput, InputFieldsContainerHolder {
    // MARK: - Properties
    private let registerView = RegisterView()
    
    // MARK: - View events
    override func loadView() {
        view = registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.drcWhite
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.drcWhite,
            NSFontAttributeName: SpecFonts.ralewayMedium(17)
        ]
        
        if let backgroundImage = UIImage.imageWithColor(UIColor.drcBlue) {
            navigationController?.navigationBar.setBackgroundImage(
                backgroundImage,
                for: .default
            )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - RegisterViewInput
    func setUserInteractionEnabled(_ isEnabled: Bool) {
        view.isUserInteractionEnabled = isEnabled
        navigationController?.navigationBar.isUserInteractionEnabled = isEnabled
        navigationController?.view.isUserInteractionEnabled = isEnabled
    }
    
    func setViewTitle(_ title: String) {
        self.title = title
    }
    
    func setAddPhotoTitle(_ title: String) {
        registerView.setAddPhotoTitle(title)
    }
    
    func setAddPhotoButtonVisible(_ visible: Bool) {
        registerView.setAddPhotoButtonVisible(visible)
    }
    
    func setAvatarPhotoImage(_ image: UIImage?) {
        registerView.setAvatarPhotoImage(image)
    }

    func setRegisterButtonTitle(_ title: String) {
        registerView.setRegisterButtonTitle(title)
    }
    
    func setOnDoneButtonTap(field: InputField, onDoneButtonTap: (() -> ())?) {
        registerView.setOnDoneButtonTap(field: field, onDoneButtonTap: onDoneButtonTap)
    }
    
    func endEditing() {
        registerView.endEditing(true)
    }
    
    var onRegisterButtonTap: (() -> ())? {
        get { return registerView.onRegisterButtonTap }
        set { registerView.onRegisterButtonTap = newValue }
    }
    
    var onAddPhotoButtonTap: (() -> ())? {
        get { return registerView.onAddPhotoButtonTap }
        set { registerView.onAddPhotoButtonTap = newValue }
    }
    
    // MARK: ActivityDisplayable
    func startActivity() {
        registerView.startActivity()
    }
    
    func stopActivity() {
        registerView.stopActivity()
    }
    
    // MARK: InputFieldsContainerHolder
    var inputFieldsContainer: InputFieldsContainer {
        return registerView
    }
}
