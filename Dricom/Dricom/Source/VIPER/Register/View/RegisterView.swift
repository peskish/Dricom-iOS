import UIKit

final class RegisterView: ContentScrollingView, StandardPreloaderViewHolder, ActivityDisplayable {
    // MARK: - Properties
    private let topBackgroundView = UIView()
    private let addPhotoButton = UIButton(type: .custom)
    private let avatarImageView = UIImageView(image: #imageLiteral(resourceName: "Avatar"))
    private let nameInputView = TextFieldView()
    private let emailInputView = TextFieldView()
    private let licenseInputView = TextFieldView()
    private let phoneInputView = TextFieldView()
    private let passwordInputView = TextFieldView()
    private let confirmPasswordInputView = TextFieldView()
    private let registerButtonView = ActionButtonView()
    
    let preloader = StandardPreloaderView(style: .dark)
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(topBackgroundView)
        addSubview(addPhotoButton)
        addSubview(avatarImageView)
        addSubview(nameInputView)
        addSubview(emailInputView)
        addSubview(licenseInputView)
        addSubview(phoneInputView)
        addSubview(passwordInputView)
        addSubview(confirmPasswordInputView)
        addSubview(registerButtonView)
        addSubview(preloader)
        
        keyboardDismissMode = .none
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        [nameInputView, emailInputView, licenseInputView, passwordInputView].forEach({ $0.returnKeyType = .next})
        
        emailInputView.keyboardType = .emailAddress
        phoneInputView.keyboardType = .phonePad
        
        passwordInputView.isSecureTextEntry = true
        confirmPasswordInputView.isSecureTextEntry = true
        
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .drcWhite
        
        topBackgroundView.backgroundColor = UIColor.drcBlue
        
        addPhotoButton.setImage(#imageLiteral(resourceName: "Add photo"), for: .normal)
        addPhotoButton.adjustsImageWhenHighlighted = false
        addPhotoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        
        avatarImageView.size = #imageLiteral(resourceName: "Avatar").size
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.size.height/2
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topBackgroundView.layout(
            left: bounds.left,
            right: bounds.right,
            top: bounds.top,
            height: 45
        )
        
        avatarImageView.centerX = bounds.centerX
        avatarImageView.top = bounds.top
        
        addPhotoButton.sizeToFit()
        let sizeOfText = addPhotoButton.titleLabel?.sizeThatFits() ?? .zero
        let sizeOfImage = addPhotoButton.imageView?.sizeThatFits() ?? .zero
        addPhotoButton.width = sizeOfText.width
            + sizeOfImage.width
            + addPhotoButton.titleEdgeInsets.left
            + addPhotoButton.titleEdgeInsets.right
        addPhotoButton.top = avatarImageView.bottom + 10
        addPhotoButton.centerX = bounds.centerX
        
        nameInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: addPhotoButton.bottom + SpecMargins.contentMargin,
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
        
        preloader.frame = bounds
        
        contentSize = CGSize(
            width: bounds.width,
            height: registerButtonView.bottom + SpecMargins.contentMargin
        )
    }
    
    // MARK: Public
    func setAddPhotoTitle(_ title: String) {
        var attributes: [String: Any] = [
            NSForegroundColorAttributeName: UIColor.drcBlue,
            NSFontAttributeName: UIFont.drcAddPhotoFont() ?? .systemFont(ofSize: 15)
        ]
        let normalTitle = NSAttributedString(string: title, attributes: attributes)
        
        attributes[NSForegroundColorAttributeName] = UIColor.drcWarmBlue
        let highlightedTitle = NSAttributedString(string: title, attributes: attributes)
            
        addPhotoButton.setAttributedTitle(normalTitle, for: .normal)
        addPhotoButton.setAttributedTitle(highlightedTitle, for: .highlighted)
        
        setNeedsLayout()
    }
    
    func setAvatarPhotoImage(_ image: UIImage?) {
        avatarImageView.image = image ?? #imageLiteral(resourceName: "Avatar")
    }
    
    func setRegisterButtonTitle(_ title: String) {
        registerButtonView.setTitle(title)
    }
    
    var onAddPhotoButtonTap: (() -> ())?
    
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
