import UIKit

final class LoginOrRegisterViewController: BaseViewController, LoginOrRegisterViewInput {
    private let loginOrRegisterView = LoginOrRegisterView()
    
    override func loadView() {
        super.loadView()
        
        view = loginOrRegisterView
    }
    
    // MARK: - LoginOrRegisterViewInput
    func setLoginButtonTitle(_ title: String) {
        loginOrRegisterView.setLoginButtonTitle(title)
    }
    
    func setRegisterButtonTitle(_ title: String) {
        loginOrRegisterView.setRegisterButtonTitle(title)
    }
    
    var onLoginButtonTap: (() -> ())? {
        get { return loginOrRegisterView.onLoginButtonTap }
        set { loginOrRegisterView.onLoginButtonTap = newValue }
    }
    
    var onRegisterButtonTap: (() -> ())? {
        get { return loginOrRegisterView.onRegisterButtonTap }
        set { loginOrRegisterView.onRegisterButtonTap = newValue }
    }
    
    var onInfoButtonTap: (() -> ())? {
        get { return loginOrRegisterView.onInfoButtonTap }
        set { loginOrRegisterView.onInfoButtonTap = newValue }
    }
}
