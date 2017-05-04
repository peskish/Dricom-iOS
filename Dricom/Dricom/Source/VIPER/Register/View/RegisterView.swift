import UIKit

final class RegisterView: UIView, ActivityDisplayable, StandardPreloaderViewHolder, InputFieldsContainer {
    // MARK: - Properties
    private let topContainer = RegisterTopView()
    private let inputFieldsContainer = UIScrollView()
    
    private let nameInputView = TextFieldView()
    private let emailInputView = TextFieldView()
    private let licenseInputView = TextFieldView()
    private let phoneInputView = TextFieldView()
    private let passwordInputView = TextFieldView()
    private let confirmPasswordInputView = TextFieldView()
    private let registerButtonView = ActionButtonView()
    
    let preloader = StandardPreloaderView(style: .darkClearBackground)
    
    private let keyboardAvoidingService = ScrollViewKeyboardAvoidingServiceImpl()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        inputFieldsContainer.addSubview(nameInputView)
        inputFieldsContainer.addSubview(emailInputView)
        inputFieldsContainer.addSubview(licenseInputView)
        inputFieldsContainer.addSubview(phoneInputView)
        inputFieldsContainer.addSubview(passwordInputView)
        inputFieldsContainer.addSubview(confirmPasswordInputView)
        inputFieldsContainer.addSubview(registerButtonView)
        
        addSubview(inputFieldsContainer)
        addSubview(topContainer)
        addSubview(preloader)
        
        inputFieldsContainer.keyboardDismissMode = .none
        inputFieldsContainer.showsVerticalScrollIndicator = false
        inputFieldsContainer.showsHorizontalScrollIndicator = false
        
        [nameInputView, emailInputView, licenseInputView, passwordInputView].forEach({ $0.returnKeyType = .next})
        
        emailInputView.keyboardType = .emailAddress
        phoneInputView.keyboardType = .phonePad
        
        passwordInputView.isSecureTextEntry = true
        confirmPasswordInputView.isSecureTextEntry = true
        
        keyboardAvoidingService.attachToScrollView(inputFieldsContainer, contentInsetOutput: inputFieldsContainer)
        
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .drcWhite
        registerButtonView.style = .dark
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topContainer.size = topContainer.sizeThatFits(bounds.size)
        topContainer.top = bounds.top
        
        // Input fields
        nameInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: topContainer.height,
            height: SpecSizes.inputFieldHeight
        )
        
        emailInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: nameInputView.bottom,
            height: SpecSizes.inputFieldHeight
        )
        
        licenseInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: emailInputView.bottom,
            height: SpecSizes.inputFieldHeight
        )
        
        phoneInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: licenseInputView.bottom,
            height: SpecSizes.inputFieldHeight
        )
        
        passwordInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: phoneInputView.bottom,
            height: SpecSizes.inputFieldHeight
        )
        
        confirmPasswordInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: passwordInputView.bottom,
            height: SpecSizes.inputFieldHeight
        )
        
        registerButtonView.layout(
            left: bounds.left,
            right: bounds.right,
            top: confirmPasswordInputView.bottom + SpecMargins.contentMargin,
            height: SpecSizes.actionButtonHeight
        )
        
        inputFieldsContainer.frame = bounds
        preloader.frame = bounds
        
        inputFieldsContainer.contentSize = CGSize(
            width: bounds.width,
            height: registerButtonView.bottom + SpecMargins.contentMargin
        )
    }
    
    // MARK: Public
    func setAddPhotoTitle(_ title: String) {
        topContainer.setAddPhotoTitle(title)
    }
    
    func setAddPhotoButtonVisible(_ visible: Bool) {
        topContainer.setAddPhotoButtonVisible(visible)
    }
    
    func setAvatarPhotoImage(_ image: UIImage?) {
        topContainer.setAvatarPhotoImage(image)
    }
    
    var onAddPhotoButtonTap: (() -> ())? {
        get { return topContainer.onAddPhotoButtonTap }
        set { topContainer.onAddPhotoButtonTap = newValue }
    }
    
    func setRegisterButtonTitle(_ title: String) {
        registerButtonView.setTitle(title)
    }
    
    var onRegisterButtonTap: (() -> ())? {
        get { return registerButtonView.onTap }
        set { registerButtonView.onTap = newValue }
    }
    
    // MARK: - InputFieldsContainer
    func inputFieldView(field: InputField) -> TextFieldView? {
        switch field {
        case .name:
            return nameInputView
        case .email:
            return emailInputView
        case .license:
            return licenseInputView
        case .phone:
            return phoneInputView
        case .password:
            return passwordInputView
        case .passwordConfirmation:
            return confirmPasswordInputView
        case .oldPassword:
            return nil
        }
    }
    
    func allFields() -> [InputField] {
        return [
            .name,
            .email,
            .license,
            .phone,
            .password,
            .passwordConfirmation
        ]
    }
}
