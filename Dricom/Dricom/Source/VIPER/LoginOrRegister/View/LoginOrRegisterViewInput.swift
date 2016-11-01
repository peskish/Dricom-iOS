import Foundation

protocol LoginOrRegisterViewInput: class, ViewLifecycleObservable {
    func setLoginButtonTitle(_ title: String)
    func setRegisterButtonTitle(_ title: String)
    
    var onLoginButtonTap: (() -> ())? { get set }
    var onRegisterButtonTap: (() -> ())? { get set }
    var onInfoButtonTap: (() -> ())? { get set }
}
