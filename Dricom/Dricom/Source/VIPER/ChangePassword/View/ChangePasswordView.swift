import UIKit

final class ChangePasswordView: UIView, ActivityDisplayable, StandardPreloaderViewHolder, InputFieldsContainer {
    // MARK: - Properties
    private let oldPasswordInputView = TextFieldView()
    private let newPasswordInputView = TextFieldView()
    private let confirmNewPasswordInputView = TextFieldView()
    
    private let confirmButtonView = ActionButtonView()
    
    let preloader = StandardPreloaderView(style: .darkClearBackground)
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(oldPasswordInputView)
        addSubview(newPasswordInputView)
        addSubview(confirmNewPasswordInputView)
        addSubview(confirmButtonView)
        
        addSubview(preloader)
        
        [oldPasswordInputView, newPasswordInputView].forEach({ $0.returnKeyType = .next})
        confirmNewPasswordInputView.returnKeyType = .done
        
        [oldPasswordInputView, newPasswordInputView, confirmNewPasswordInputView].forEach(
            { $0.isSecureTextEntry = true }
        )
        
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .drcWhite
        confirmButtonView.style = .dark
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        oldPasswordInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: SpecMargins.contentMargin,
            height: SpecSizes.inputFieldHeight
        )
        
        newPasswordInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: oldPasswordInputView.bottom,
            height: SpecSizes.inputFieldHeight
        )
        
        confirmNewPasswordInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: newPasswordInputView.bottom,
            height: SpecSizes.inputFieldHeight
        )
        
        confirmButtonView.layout(
            left: bounds.left,
            right: bounds.right,
            bottom: bounds.bottom - SpecMargins.contentSidePadding,
            height: SpecSizes.actionButtonHeight
        )
        
        preloader.frame = bounds
    }
    
    // MARK: - Public
    func setConfirmButtonTitle(_ title: String) {
        confirmButtonView.setTitle(title)
    }
    
    func setConfirmButtonEnabled(_ enabled: Bool) {
        confirmButtonView.setEnabled(enabled)
    }
    
    var onConfirmButtonTap: (() -> ())? {
        get { return confirmButtonView.onTap }
        set { confirmButtonView.onTap = newValue }
    }
    
    // MARK: - InputFieldsContainer
    func inputFieldView(field: InputField) -> TextFieldView? {
        switch field {
        case .oldPassword:
            return oldPasswordInputView
        case .password:
            return newPasswordInputView
        case .passwordConfirmation:
            return confirmNewPasswordInputView
        default:
            return nil
        }
    }
    
    func allFields() -> [InputField] {
        return [
            .oldPassword,
            .password,
            .passwordConfirmation
        ]
    }
}
