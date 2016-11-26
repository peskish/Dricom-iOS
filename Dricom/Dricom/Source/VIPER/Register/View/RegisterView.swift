import UIKit

final class RegisterView: ContentScrollingView, StandardPreloaderViewHolder, ActivityDisplayable {
    // MARK: - Properties
    private let backgroundView = RadialGradientView()
    private let addPhotoButton = ImageButtonView(image: UIImage(named: "Add photo"))
    private let addPhotoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = SpecColors.textMain
        label.textAlignment = .center
        return label
    }()
    private let nameInputView = TextFieldView()
    private let emailInputView = TextFieldView()
    private let licenseInputView = TextFieldView()
    private let phoneInputView = TextFieldView()
    private let passwordInputView = TextFieldView()
    private let confirmPasswordInputView = TextFieldView()
    private let registerButtonView = ActionButtonView()
    private let infoButtonView = ImageButtonView(image: UIImage(named: "Info sign"))
    
    let preloader = StandardPreloaderView(style: .light)
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        backgroundColor = SpecColors.Background.defaultEdge
        
        addSubview(backgroundView)
        addSubview(addPhotoButton)
        addSubview(addPhotoLabel)
        addSubview(nameInputView)
        addSubview(emailInputView)
        addSubview(licenseInputView)
        addSubview(phoneInputView)
        addSubview(passwordInputView)
        addSubview(confirmPasswordInputView)
        addSubview(registerButtonView)
        addSubview(infoButtonView)
        addSubview(preloader)
        
        keyboardDismissMode = .none
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        addPhotoButton.sizeToFit()
        addPhotoButton.layer.cornerRadius = addPhotoButton.width/2
        addPhotoButton.layer.masksToBounds = true
        
        [nameInputView, emailInputView, licenseInputView, passwordInputView].forEach({ $0.returnKeyType = .next})
        
        emailInputView.keyboardType = UIKeyboardType.emailAddress
        phoneInputView.keyboardType = UIKeyboardType.phonePad
        
        passwordInputView.isSecureTextEntry = true
        confirmPasswordInputView.isSecureTextEntry = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = bounds
        
        addPhotoButton.size = addPhotoButton.sizeThatFits(bounds.size)
        addPhotoButton.top = SpecSizes.statusBarHeight * 3
        addPhotoButton.centerX = bounds.centerX
        
        addPhotoLabel.sizeToFit()
        addPhotoLabel.top = addPhotoButton.bottom + SpecMargins.innerContentMargin
        addPhotoLabel.centerX = bounds.centerX
        
        nameInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: addPhotoLabel.bottom + 2*SpecMargins.contentMargin,
            height: SpecMargins.inputFieldHeight
        )
        
        emailInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: nameInputView.bottom + SpecMargins.innerContentMargin,
            height: SpecMargins.inputFieldHeight
        )
        
        licenseInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: emailInputView.bottom + SpecMargins.innerContentMargin,
            height: SpecMargins.inputFieldHeight
        )
        
        phoneInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: licenseInputView.bottom + SpecMargins.innerContentMargin,
            height: SpecMargins.inputFieldHeight
        )
        
        passwordInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: phoneInputView.bottom + SpecMargins.innerContentMargin,
            height: SpecMargins.inputFieldHeight
        )
        
        confirmPasswordInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: passwordInputView.bottom + SpecMargins.innerContentMargin,
            height: SpecMargins.inputFieldHeight
        )
        
        infoButtonView.size = infoButtonView.sizeThatFits(bounds.size)
        
        let lastInputFieldDesiredMaxY = frame.bottom - infoButtonView.size.height - SpecMargins.actionButtonHeight - 2*SpecMargins.contentMargin
        if confirmPasswordInputView.bottom >= lastInputFieldDesiredMaxY {
            registerButtonView.layout(
                left: bounds.left,
                right: bounds.right,
                top: confirmPasswordInputView.bottom + SpecMargins.contentMargin,
                height: SpecMargins.actionButtonHeight
            )
            infoButtonView.layout(right: bounds.right, top: registerButtonView.bottom + SpecMargins.contentMargin)
        } else {
            infoButtonView.layout(right: bounds.right, bottom: frame.height)
            registerButtonView.layout(
                left: bounds.left,
                bottom: infoButtonView.top - SpecMargins.contentMargin,
                fitWidth: bounds.width,
                fitHeight: SpecMargins.actionButtonHeight
            )
        }
        
        preloader.frame = bounds
        
        contentSize = CGSize(
            width: bounds.width,
            height: infoButtonView.bottom + SpecMargins.contentMargin
        )
    }
    
    // MARK: Public
    func setAddPhotoTitle(_ title: String) {
        addPhotoLabel.text = title
    }
    
    func setAddPhotoImage(_ image: UIImage?) {
        addPhotoButton.setImage(image ?? UIImage(named: "Add photo"))
    }
    
    func setRegisterButtonTitle(_ title: String) {
        registerButtonView.setTitle(title)
    }
    
    var onAddPhotoButtonTap: (() -> ())? {
        get { return addPhotoButton.onTap }
        set { addPhotoButton.onTap = newValue }
    }
    
    var onRegisterButtonTap: (() -> ())? {
        get { return registerButtonView.onTap }
        set { registerButtonView.onTap = newValue }
    }
    
    var onInfoButtonTap: (() -> ())? {
        get { return infoButtonView.onTap }
        set { infoButtonView.onTap = newValue }
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
