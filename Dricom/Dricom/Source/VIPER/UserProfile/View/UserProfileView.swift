import UIKit
import AlamofireImage

final class UserProfileView: UIView, ActivityDisplayable, StandardPreloaderViewHolder, InputFieldsContainer {
    let preloader = StandardPreloaderView(style: .dark)
    
    private let changePhotoButton = UIButton(type: .custom)
    private let avatarImageView = UIImageView(image: #imageLiteral(resourceName: "Avatar"))
    private let avatarTapGesture = UITapGestureRecognizer(
        target: self,
        action: #selector(changePhotoPressed)
    )
    private let nameInputView = TextFieldView()
    private let emailInputView = TextFieldView()
    private let phoneInputView = TextFieldView()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(avatarImageView)
        addSubview(changePhotoButton)
        
        addSubview(nameInputView)
        addSubview(emailInputView)
        addSubview(phoneInputView)
        
        addSubview(preloader)
        
        emailInputView.keyboardType = .emailAddress
        phoneInputView.keyboardType = .phonePad
        
        changePhotoButton.addTarget(self, action: #selector(changePhotoPressed), for: .touchUpInside)
        
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(avatarTapGesture)
        
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Style
    private func setStyle() {
        backgroundColor = .drcWhite
        
        avatarImageView.size = #imageLiteral(resourceName: "Avatar").size
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.size.height/2
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.centerX = bounds.centerX
        avatarImageView.top = bounds.top + 15
        
        changePhotoButton.sizeToFit()
        changePhotoButton.top = avatarImageView.bottom + 10
        changePhotoButton.centerX = bounds.centerX
        
        // Input fields
        nameInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: changePhotoButton.bottom + 20,
            height: SpecSizes.inputFieldHeight
        )
        
        emailInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: nameInputView.bottom,
            height: SpecSizes.inputFieldHeight
        )
        
        phoneInputView.layout(
            left: bounds.left,
            right: bounds.right,
            top: emailInputView.bottom,
            height: SpecSizes.inputFieldHeight
        )
    }
    
    private var inputFields: [TextFieldView] {
        return [nameInputView, emailInputView, phoneInputView]
    }
    
    // MARK: - Public
    func setAddPhotoTitle(_ title: String) {
        var attributes: [String: Any] = [
            NSForegroundColorAttributeName: UIColor.drcBlue,
            NSFontAttributeName: UIFont.drcAddPhotoFont() ?? .systemFont(ofSize: 15)
        ]
        let normalTitle = NSAttributedString(string: title, attributes: attributes)
        
        attributes[NSForegroundColorAttributeName] = UIColor.drcWarmBlue
        let highlightedTitle = NSAttributedString(string: title, attributes: attributes)
        
        changePhotoButton.setAttributedTitle(normalTitle, for: .normal)
        changePhotoButton.setAttributedTitle(highlightedTitle, for: .highlighted)
        
        setNeedsLayout()
    }
    
    func setAddPhotoTitleVisible(_ isVisible: Bool) {
        changePhotoButton.isHidden = !isVisible
    }
    
    func setInputFieldsEnabled(_ isEnabled: Bool) {
        inputFields.forEach({ $0.isEnabled = isEnabled })
    }
    
    func setAvatarSelectionEnabled(_ isEnabled: Bool) {
        avatarTapGesture.isEnabled = isEnabled
        changePhotoButton.isEnabled = isEnabled
    }
    
    func setAvatarPhotoImage(_ image: UIImage?) {
        avatarImageView.image = image ?? #imageLiteral(resourceName: "Avatar")
    }
    
    func setAvatarImageUrl(_ avatarImageUrl: URL?) {
        guard let avatarImageUrl = avatarImageUrl else {
            avatarImageView.image = #imageLiteral(resourceName: "Avatar")
            return
        }
        
        let imageFilter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: avatarImageView.size,
            radius: avatarImageView.size.width/2
        )
        
        avatarImageView.af_setImage(
            withURL: avatarImageUrl,
            placeholderImage: nil,
            filter: imageFilter,
            imageTransition: .crossDissolve(0.3)
        )
    }
    
    var onChangePhotoButtonTap: (() -> ())?
    
    // MARK: - Private
    @objc private func changePhotoPressed() {
        onChangePhotoButtonTap?()
    }
    
    // MARK: - InputFieldsContainer
    func inputFieldView(field: InputField) -> TextFieldView? {
        switch field {
        case .name:
            return nameInputView
        case .email:
            return emailInputView
        case .phone:
            return phoneInputView
        default:
            return nil
        }
    }
    
    func allFields() -> [InputField] {
        return [
            .name,
            .email,
            .phone
        ]
    }
}
