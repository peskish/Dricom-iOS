import UIKit

final class LoginView: ContentScrollingView, StandardPreloaderViewHolder, ActivityDisplayable {
    // MARK: Properties
    private let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"))
    private let logoTitleView = UILabel()
    private let illustration = UIImageView(image: #imageLiteral(resourceName: "City illustration"))
    private let loginInputView = TextFieldView()
    private let passwordView = TextFieldView()
    private let loginButtonView = ActionButtonView()
    private let registerButtonView = ActionButtonView()
    private let infoButtonView = ImageButtonView(image: UIImage(named: "Info sign"))
    
    let preloader = StandardPreloaderView(style: .dark)
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .drcWhite
        
        addSubview(illustration)
        addSubview(logoImageView)
        addSubview(logoTitleView)
        addSubview(loginInputView)
        addSubview(passwordView)
        addSubview(loginButtonView)
        addSubview(registerButtonView)
        addSubview(infoButtonView)
        addSubview(preloader)
        
        logoTitleView.text = "DRICOM" // this is used as a part of design without any logic
        
        keyboardDismissMode = .none
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        loginInputView.returnKeyType = .next
        
        loginInputView.onDoneButtonTap = { [weak self] in
            self?.passwordView.startEditing()
        }
        
        passwordView.isSecureTextEntry = true
        passwordView.returnKeyType = .done
        
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        logoTitleView.font = UIFont.drcLogoMediumFont()
        logoTitleView.textColor = .drcLightBlue
        logoTitleView.textAlignment = .center
        
        loginButtonView.style = .dark
        registerButtonView.style = .light
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        logoImageView.sizeToFit()
        logoImageView.top = 75
        logoImageView.centerX = bounds.centerX
        
        logoTitleView.sizeToFit()
        logoTitleView.centerX = centerX
        logoTitleView.top = logoImageView.bottom + 4
        
        illustration.size = illustration.sizeThatFits(
            CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
        )
        illustration.top = logoImageView.top + 3
        
        loginInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: illustration.bottom,
            height: SpecSizes.inputFieldHeight
        )
        
        passwordView.layout(
            left: bounds.left,
            right: bounds.right,
            top: loginInputView.bottom,
            height: SpecSizes.inputFieldHeight
        )
        
        loginButtonView.layout(
            left: bounds.left,
            right: bounds.right,
            top: passwordView.bottom + SpecMargins.contentSidePadding,
            height: SpecSizes.actionButtonHeight
        )
        
        registerButtonView.layout(
            left: bounds.left,
            right: bounds.right,
            top: loginButtonView.bottom + SpecMargins.contentMargin,
            height: SpecSizes.actionButtonHeight
        )
        
        infoButtonView.size = infoButtonView.sizeThatFits(bounds.size)
        infoButtonView.layout(right: bounds.right, top: registerButtonView.bottom + SpecMargins.contentMargin)

        preloader.frame = bounds
        
        contentSize = CGSize(width: bounds.width, height: max(bounds.height, infoButtonView.bottom))
    }
    
    // MARK: Public
    func setLoginPlaceholder(_ placeholder: String?) {
        loginInputView.placeholder = placeholder
    }
    
    func setLoginValue(_ value: String?) {
        loginInputView.text = value
    }
    
    func setLoginButtonTitle(_ title: String?) {
        loginButtonView.setTitle(title)
    }
    
    func setPasswordPlaceholder(_ placeholder: String?) {
        passwordView.placeholder = placeholder
    }
    
    func setRegisterButtonTitle(_ title: String) {
        registerButtonView.setTitle(title)
    }
    
    var onLoginChange: ((String?) -> ())? {
        get { return loginInputView.onTextChange }
        set { loginInputView.onTextChange = newValue }
    }
    
    var onPasswordChange: ((String?) -> ())? {
        get { return passwordView.onTextChange }
        set { passwordView.onTextChange = newValue }
    }
    
    var onLoginButtonTap: (() -> ())? {
        get { return loginButtonView.onTap }
        set { loginButtonView.onTap = newValue }
    }
    
    var onRegisterButtonTap: (() -> ())? {
        get { return registerButtonView.onTap }
        set { registerButtonView.onTap = newValue }
    }
    
    var onInfoButtonTap: (() -> ())? {
        get { return infoButtonView.onTap }
        set { infoButtonView.onTap = newValue }
    }
    
    func focusOnLoginField() {
        loginInputView.startEditing()
    }
    
    func focusOnPasswordField() {
        passwordView.startEditing()
    }
    
    func setLoginFieldState(_ state: InputFieldViewState) {
        loginInputView.state = state
    }
    
    func setPasswordFieldState(_ state: InputFieldViewState) {
        passwordView.state = state
    }
}
