import UIKit

final class LoginView: ContentScrollingView, StandardPreloaderViewHolder, ActivityDisplayable {
    // MARK: Properties
    private let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"))
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
        
        addSubview(logoImageView)
        addSubview(loginInputView)
        addSubview(passwordView)
        addSubview(loginButtonView)
        addSubview(registerButtonView)
        addSubview(infoButtonView)
        addSubview(preloader)
        
        keyboardDismissMode = .none
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        loginInputView.returnKeyType = .next
        
        loginInputView.onDoneButtonTap = { [weak self] in
            self?.passwordView.startEditing()
        }
        
        passwordView.isSecureTextEntry = true
        passwordView.returnKeyType = .done
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let imageSize = logoImageView.image?.size else { return .zero }
        
        var desiredHeight: CGFloat = SpecSizes.statusBarHeight * 2
        desiredHeight += imageSize.height/2
        desiredHeight += 2*SpecMargins.contentMargin + loginInputView.sizeThatFits(size).height
        desiredHeight += SpecMargins.innerContentMargin + passwordView.sizeThatFits(size).height
        desiredHeight += SpecMargins.contentMargin + loginButtonView.sizeThatFits(size).height
        desiredHeight += SpecMargins.contentMargin + registerButtonView.sizeThatFits(size).height
        desiredHeight += SpecMargins.contentMargin + SpecSizes.bottomAreaHeight
        
        return CGSize(width: size.width, height: desiredHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        logoImageView.sizeToFit()
        logoImageView.top = 75
        logoImageView.centerX = bounds.centerX
        
        let desiredSize = sizeThatFits(frame.size)
        
        if desiredSize.height > frame.height {
            layoutFromTop()
        } else {
            layoutFromBottom()
        }

        preloader.frame = bounds
        
        contentSize = CGSize(width: bounds.width, height: max(bounds.height, infoButtonView.bottom))
    }
    
    private func layoutFromBottom() {
        infoButtonView.size = infoButtonView.sizeThatFits(bounds.size)
        infoButtonView.layout(right: bounds.right, bottom: frame.height)
        
        registerButtonView.layout(
            left: bounds.left,
            bottom: infoButtonView.top - SpecMargins.innerContentMargin,
            fitWidth: bounds.width,
            fitHeight: SpecMargins.actionButtonHeight
        )
        
        loginButtonView.layout(
            left: bounds.left,
            bottom: registerButtonView.top - SpecMargins.contentMargin,
            fitWidth: bounds.width,
            fitHeight: SpecMargins.actionButtonHeight
        )
        
        passwordView.layout(
            left: bounds.left,
            right: bounds.right,
            bottom: loginButtonView.top - SpecMargins.contentMargin,
            height: SpecMargins.inputFieldHeight
        )
        
        loginInputView.layout(
            left: bounds.left,
            right: bounds.right,
            bottom: passwordView.top - SpecMargins.innerContentMargin,
            height: SpecMargins.inputFieldHeight
        )
    }
    
    private func layoutFromTop() {
        loginInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: logoImageView.bottom + 2*SpecMargins.contentMargin,
            height: SpecMargins.inputFieldHeight
        )
        
        passwordView.layout(
            left: bounds.left,
            right: bounds.right,
            top: loginInputView.bottom + SpecMargins.innerContentMargin,
            height: SpecMargins.inputFieldHeight
        )
        
        loginButtonView.layout(
            left: bounds.left,
            right: bounds.right,
            top: passwordView.bottom + SpecMargins.contentMargin,
            height: SpecMargins.actionButtonHeight
        )
        
        registerButtonView.layout(
            left: bounds.left,
            right: bounds.right,
            top: loginButtonView.bottom + SpecMargins.contentMargin,
            height: SpecMargins.actionButtonHeight
        )
        
        infoButtonView.size = infoButtonView.sizeThatFits(bounds.size)
        infoButtonView.layout(right: bounds.right, top: registerButtonView.bottom + SpecMargins.contentMargin)
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
