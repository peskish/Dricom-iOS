import UIKit

// TODO: Add "Remember login" checkbox

final class LoginView: UIView {
    // MARK: Properties
    private let backgroundView = RadialGradientView()
    private let logoImageView = UIImageView(image: UIImage(named: "Logo"))
    private let loginView = TextFieldView()
    private let passwordView = TextFieldView()
    private let loginButtonView = ActionButtonView()
    private let infoButtonView = InfoButtonView()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(backgroundView)
        addSubview(logoImageView)
        addSubview(loginView)
        addSubview(passwordView)
        addSubview(loginButtonView)
        addSubview(infoButtonView)
        
        loginButtonView.onTap = { [onLoginButtonTap] in
            onLoginButtonTap?()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // TODO: Layout
        
    }
    
    // MARK: Public
    func setLoginPlaceholder(_ placeholder: String?) {
        loginView.placeholder = placeholder
    }
    
    func setLoginValue(_ value: String?) {
        loginView.text = value
    }
    
    func setPasswordPlaceholder(_ placeholder: String?) {
        passwordView.placeholder = placeholder
    }
    
    var onLoginChange: ((String?) -> ())? {
        get { return loginView.onTextChange }
        set { loginView.onTextChange = newValue }
    }
    
    var onPasswordChange: ((String?) -> ())? {
        get { return passwordView.onTextChange }
        set { passwordView.onTextChange = newValue }
    }
    
    var onLoginButtonTap: (() -> ())? {
        get { return loginButtonView.onTap }
        set { loginButtonView.onTap = newValue }
    }
    
    func setRememberLoginChecked(_ checked: Bool) {
        
    }
    
    var onRememberLoginValueChange: (() -> ())?
}
