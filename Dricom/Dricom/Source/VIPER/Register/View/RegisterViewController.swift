import UIKit

final class RegisterViewController: ContentScrollingViewController, RegisterViewInput {
    // MARK: - Properties
    private let registerView = RegisterView()
    
    // MARK: - View events
    override func loadView() {
        super.loadView()
        
        view = registerView
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        registerView.initialInsets = .zero
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.drcWhite
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.drcWhite,
            NSFontAttributeName: UIFont.drcScreenNameFont() ?? UIFont.systemFont(ofSize: 17)
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
    
    func setOnInputChange(field: RegisterInputField, onChange: ((String?) -> ())?) {
        registerView.setOnInputChange(field: field, onChange: onChange)
    }
    
    func setInputPlaceholder(field: RegisterInputField, placeholder: String?) {
        registerView.setInputPlaceholder(field: field, placeholder: placeholder)
    }
    
    func focusOnField(_ field: RegisterInputField?) {
        registerView.focusOnField(field)
    }
    
    func setStateAccordingToErrors(_ errors: [RegisterInputFieldError]) {
        registerView.setStateAccordingToErrors(errors)
    }
    
    func setState(_ state: InputFieldViewState, to field: RegisterInputField) {
        registerView.setState(state, to: field)
    }
    
    func setOnDoneButtonTap(field: RegisterInputField, onDoneButtonTap: (() -> ())?) {
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
}
