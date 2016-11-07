import UIKit

final class LoginView: ContentScrollingView {
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
        
        backgroundColor = SpecColors.Background.defaultEdge
        
        addSubview(backgroundView)
        addSubview(logoImageView)
        addSubview(loginView)
        addSubview(passwordView)
        addSubview(loginButtonView)
        addSubview(infoButtonView)
        
        loginButtonView.onTap = { [onLoginButtonTap] in
            onLoginButtonTap?()
        }
        
        keyboardDismissMode = .none
        
        loginView.returnKeyType = .next
        
        loginView.onDoneButtonTap = { [weak self] in
            self?.passwordView.startEditing()
        }
        
        passwordView.isSecureTextEntry = true
        passwordView.returnKeyType = .done
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = bounds
        
        // Logo image has strange size (too big) - i'll try to use the half of it for now
        guard let imageSize = logoImageView.image?.size else { return }
        
        logoImageView.size = CGSize(width: imageSize.width/2, height: imageSize.height/2)
        logoImageView.top = SpecSizes.statusBarHeight * 2
        logoImageView.centerX = bounds.centerX
        
        infoButtonView.size = infoButtonView.sizeThatFits(bounds.size)
        infoButtonView.layout(right: bounds.right, bottom: frame.bottom)
        
        loginButtonView.layout(
                left: bounds.left,
                bottom: infoButtonView.top - SpecMargins.contentMargin,
                fitWidth: bounds.width,
                fitHeight: SpecMargins.actionButtonHeight
        )
        
        passwordView.layout(
            left: bounds.left,
            right: bounds.right,
            bottom: loginButtonView.top - SpecMargins.contentMargin,
            height: SpecMargins.inputFieldHeight
        )
        
        loginView.layout(
            left: bounds.left,
            right: bounds.right,
            bottom: passwordView.top - SpecMargins.innerContentMargin,
            height: SpecMargins.inputFieldHeight
        )
        
        contentSize = CGSize(width: bounds.width, height: max(bounds.height, infoButtonView.bottom))
    }
    
    // MARK: Public
    func setLoginPlaceholder(_ placeholder: String?) {
        loginView.placeholder = placeholder
    }
    
    func setLoginValue(_ value: String?) {
        loginView.text = value
    }
    
    func setLoginButtonTitle(_ title: String?) {
        loginButtonView.setTitle(title)
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
    
    func focusOnLoginField() {
        loginView.startEditing()
    }
    
    func focusOnPasswordField() {
        passwordView.startEditing()
    }
    
    func setLoginFieldState(_ state: InputFieldViewState) {
        loginView.state = state
    }
    
    func setPasswordFieldState(_ state: InputFieldViewState) {
        passwordView.state = state
    }
}
