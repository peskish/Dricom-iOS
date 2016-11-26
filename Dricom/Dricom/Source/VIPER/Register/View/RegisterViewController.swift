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
    
    // MARK: - RegisterViewInput
    func setAddPhotoTitle(_ title: String) {
        registerView.setAddPhotoTitle(title)
    }
    
    func setAddPhotoImage(_ image: UIImage?) {
        registerView.setAddPhotoImage(image)
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
    
    var onInfoButtonTap: (() -> ())? {
        get { return registerView.onInfoButtonTap }
        set { registerView.onInfoButtonTap = newValue }
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
