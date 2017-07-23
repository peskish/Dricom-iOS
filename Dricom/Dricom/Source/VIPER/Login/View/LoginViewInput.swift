import Foundation

protocol LoginViewInput: class, ViewLifecycleObservable, MessageDisplayable, ViewControllerPositionHolder, ActivityDisplayable {
    func setLoginPlaceholder(_ placeholder: String?)
    func setLoginValue(_ value: String?)
    func setLoginButtonTitle(_ title: String?)
    func setPasswordPlaceholder(_ placeholder: String?)
    func setRegisterButtonTitle(_ title: String)
    func setContactButtonTitle(_ title: String)
    
    func focusOnLoginField()
    func focusOnPasswordField()
    func setLoginFieldState(_ state: InputFieldViewState)
    func setPasswordFieldState(_ state: InputFieldViewState)
    
    func endEditing()
    
    var onLoginChange: ((String?) -> ())? { get set }
    var onPasswordChange: ((String?) -> ())? { get set }
    var onLoginButtonTap: (() -> ())? { get set }
    var onRegisterButtonTap: (() -> ())? { get set }
    var onContactButtonTap: (() -> ())? { get set }
}
