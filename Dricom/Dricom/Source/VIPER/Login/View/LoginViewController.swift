import UIKit

final class LoginViewController: BaseViewController, LoginViewInput {
    // MARK: - Properties
    private let loginView = LoginView()
    
    // MARK: - View events
    override func loadView() {
        super.loadView()
        
        view = loginView
    }
    
    // MARK: - LoginViewInput
    func setLoginPlaceholder(_ placeholder: String?) {
        loginView.setLoginPlaceholder(placeholder)
    }
    
    func setLoginValue(_ value: String?) {
        loginView.setLoginValue(value)
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
