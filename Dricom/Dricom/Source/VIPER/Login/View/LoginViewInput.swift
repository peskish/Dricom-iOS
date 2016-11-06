import Foundation

protocol LoginViewInput: class, ViewLifecycleObservable, MessageDisplayable, ViewControllerPositionHolder {
    func setLoginPlaceholder(_ placeholder: String?)
    func setLoginValue(_ value: String?)
    func setLoginButtonTitle(_ title: String?)
    func setPasswordPlaceholder(_ placeholder: String?)
    func setRememberLoginChecked(_ checked: Bool)
    
    var onLoginChange: ((String?) -> ())? { get set }
    var onPasswordChange: ((String?) -> ())? { get set }
    var onLoginButtonTap: (() -> ())? { get set }
    var onRememberLoginValueChange: (() -> ())? { get set }
}
