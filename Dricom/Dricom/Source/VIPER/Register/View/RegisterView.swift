import UIKit

final class RegisterView: UIView, ActivityDisplayable, StandardPreloaderViewHolder {
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
    
    let preloader = StandardPreloaderView(style: .dark)
    
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
        
        let lastInputFieldDesiredMaxY = frame.bottom
            - SpecMargins.contentSidePadding
            - SpecSizes.actionButtonHeight
            - SpecMargins.contentMargin
        
        if confirmPasswordInputView.bottom >= lastInputFieldDesiredMaxY {
            registerButtonView.layout(
                left: bounds.left,
                right: bounds.right,
                top: confirmPasswordInputView.bottom + SpecMargins.contentMargin,
                height: SpecSizes.actionButtonHeight
            )
        } else {
            registerButtonView.layout(
                left: bounds.left,
                bottom: bounds.bottom - SpecMargins.contentSidePadding,
                fitWidth: bounds.width,
                fitHeight: SpecSizes.actionButtonHeight
            )
        }
        
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
    
    func focusOnField(_ field: RegisterInputField?) {
        guard let field = field else { return }
        
        let inputField = inputFieldView(field: field)
        inputField.startEditing()
    }
    
    func setOnInputChange(field: RegisterInputField, onChange: ((String?) -> ())?) {
        let inputField = inputFieldView(field: field)
        inputField.onTextChange = onChange
    }
    
    func setOnDoneButtonTap(field: RegisterInputField, onDoneButtonTap: (() -> ())?) {
        let inputField = inputFieldView(field: field)
        inputField.onDoneButtonTap = onDoneButtonTap
    }
    
    func setInputPlaceholder(field: RegisterInputField, placeholder: String?) {
        let inputField = inputFieldView(field: field)
        inputField.placeholder = placeholder
    }
    
    func setStateAccordingToErrors(_ errors: [RegisterInputFieldError]) {
        allFields().forEach{ field in
            let state: InputFieldViewState = errors.contains(where: { $0.field == field })
                ? .validationError
                : .normal
            
            let inputView = self.inputFieldView(field: field)
            inputView.state = state
        }
    }
    
    func setState(_ state: InputFieldViewState, to field: RegisterInputField) {
        let inputField = inputFieldView(field: field)
        inputField.state = state
    }
    
    // MARK: - Private
    private func inputFieldView(field: RegisterInputField) -> TextFieldView {
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
        }
    }
    
    private func allFields() -> [RegisterInputField] {
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
