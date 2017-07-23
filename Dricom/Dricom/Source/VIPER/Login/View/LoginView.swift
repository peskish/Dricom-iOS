import UIKit

final class LoginView: UIScrollView, StandardPreloaderViewHolder, ActivityDisplayable {
    // MARK: Properties
    private let logoTitleView = UILabel()
    private let illustration = UIImageView(image: #imageLiteral(resourceName: "Login illustration"))
    private let loginInputView = TextFieldView()
    private let passwordView = TextFieldView()
    private let loginButtonView = ActionButtonView()
    private let registerButtonView = ActionButtonView()
    private let contactButton = UIButton(type: UIButtonType.custom)
    
    let preloader = StandardPreloaderView(style: .dark)
    
    private let keyboardAvoidingService = ScrollViewKeyboardAvoidingServiceImpl()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .drcWhite
        
        addSubview(logoTitleView)
        addSubview(illustration)
        addSubview(loginInputView)
        addSubview(passwordView)
        addSubview(loginButtonView)
        addSubview(registerButtonView)
        addSubview(contactButton)
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
        
        keyboardAvoidingService.attachToScrollView(self, contentInsetOutput: self)
        
        contactButton.addTarget(self, action: #selector(handleContactButtonTap(_:)), for: .touchUpInside)
        
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        logoTitleView.font = SpecFonts.ralewayBold(24)
        logoTitleView.textColor = .drcBlue
        logoTitleView.textAlignment = .center
        
        loginButtonView.style = .dark
        registerButtonView.style = .light
        
        contactButton.titleLabel?.font = SpecFonts.ralewayRegular(14)
        contactButton.setTitleColor(.drcCoolGrey, for: .normal)
        contactButton.setTitleColor(.drcSlate, for: .highlighted)
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        logoTitleView.sizeToFit()
        logoTitleView.centerX = centerX
        logoTitleView.top = 50
        
        illustration.size = illustration.sizeThatFits(
            CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
        )
        illustration.top = logoTitleView.bottom + 30
        
        loginInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: illustration.bottom + 60,
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
        
        contactButton.left = SpecMargins.contentMargin
        contactButton.size = contactButton.sizeThatFits(
            CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
        )
        contactButton.top = registerButtonView.bottom + 20
        
        preloader.frame = bounds
        
        contentSize = CGSize(
            width: bounds.width,
            height: max(bounds.height, contactButton.bottom + 5)
        )
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
    
    func setContactButtonTitle(_ title: String) {
        contactButton.setTitle(title, for: .normal)
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
    
    var onContactButtonTap: (() -> ())?
    @objc private func handleContactButtonTap(_ sender: UIButton) {
        onContactButtonTap?()
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
