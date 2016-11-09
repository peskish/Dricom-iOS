import Foundation

protocol LoginViewInput: class, ViewLifecycleObservable, MessageDisplayable, ViewControllerPositionHolder {
    func setLoginPlaceholder(_ placeholder: String?)
    func setLoginValue(_ value: String?)
    func setLoginButtonTitle(_ title: String?)
    func setPasswordPlaceholder(_ placeholder: String?)
    
    func focusOnLoginField()
    func focusOnPasswordField()
    func setLoginFieldState(_ state: InputFieldViewState)
    func setPasswordFieldState(_ state: InputFieldViewState)
    
    func endEditing()
    
    var onLoginChange: ((String?) -> ())? { get set }
    var onPasswordChange: ((String?) -> ())? { get set }
    var onLoginButtonTap: (() -> ())? { get set }
    var onInfoButtonTap: (() -> ())? { get set }
}
