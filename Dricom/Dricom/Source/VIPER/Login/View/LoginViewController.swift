import UIKit

final class LoginViewController: BaseViewController, LoginViewInput {
    // MARK: - Properties
    private let loginView = LoginView()
    
    // MARK: - View events
    override func loadView() {
        super.loadView()
        
        view = loginView
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        loginView.initialInsets = .zero
    }
    
    // MARK: - LoginViewInput
    func setLoginPlaceholder(_ placeholder: String?) {
        loginView.setLoginPlaceholder(placeholder)
    }
    
    func setLoginValue(_ value: String?) {
        loginView.setLoginValue(value)
    }
    
    func setLoginButtonTitle(_ title: String?) {
        loginView.setLoginButtonTitle(title)
    }
    
    func setPasswordPlaceholder(_ placeholder: String?) {
        loginView.setPasswordPlaceholder(placeholder)
    }
    
    func setRememberLoginChecked(_ checked: Bool) {
        loginView.setRememberLoginChecked(checked)
    }
    
    var onLoginChange: ((String?) -> ())? {
        get { return loginView.onLoginChange }
        set { loginView.onLoginChange = newValue }
    }
    
    var onPasswordChange: ((String?) -> ())? {
        get { return loginView.onPasswordChange }
        set { loginView.onPasswordChange = newValue }
    }
    
    var onLoginButtonTap: (() -> ())? {
        get { return loginView.onLoginButtonTap }
        set { loginView.onLoginButtonTap = newValue }
    }
    
    var onRememberLoginValueChange: (() -> ())? {
        get { return loginView.onRememberLoginValueChange }
        set { loginView.onRememberLoginValueChange = newValue }
    }
}
