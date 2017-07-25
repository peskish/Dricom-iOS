import UIKit

final class RegisterTopView: UIView {
    // MARK: - Properties
    private let topBackgroundView = UIView()
    private let addPhotoButton = UIButton(type: .custom)
    private let avatarImageView = UIImageView(image: #imageLiteral(resourceName: "Avatar"))
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(topBackgroundView)
        addSubview(addPhotoButton)
        addSubview(avatarImageView)
        
        addPhotoButton.addTarget(self, action: #selector(addPhotoPressed), for: .touchUpInside)
        
        avatarImageView.isUserInteractionEnabled = true
        let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(addPhotoPressed))
        avatarImageView.addGestureRecognizer(avatarTapGesture)
        
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private let addPhotoButtonPadding: CGFloat = 10
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let avatarImageViewSize = avatarImageView.sizeThatFits(size)
        let addPhotoButtonSize = addPhotoButton.sizeThatFits(size)
        
        let height = avatarImageViewSize.height
            + addPhotoButtonPadding
            + addPhotoButtonSize.height
            + SpecMargins.contentMargin
        
        return CGSize(width: size.width, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Top views
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
        addPhotoButton.top = avatarImageView.bottom + addPhotoButtonPadding
        addPhotoButton.centerX = bounds.centerX
    }
    
    // MARK: - Style
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
    
    // MARK: - Public
    func setAddPhotoTitle(_ title: String) {
        var attributes: [String: Any] = [
            NSForegroundColorAttributeName: UIColor.drcBlue,
            NSFontAttributeName: SpecFonts.ralewayRegular(15)
        ]
        let normalTitle = NSAttributedString(string: title, attributes: attributes)
        
        attributes[NSForegroundColorAttributeName] = UIColor.drcWarmBlue
        let highlightedTitle = NSAttributedString(string: title, attributes: attributes)
        
        addPhotoButton.setAttributedTitle(normalTitle, for: .normal)
        addPhotoButton.setAttributedTitle(highlightedTitle, for: .highlighted)
        
        setNeedsLayout()
    }
    
    func setAddPhotoButtonVisible(_ visible: Bool) {
        addPhotoButton.isHidden = !visible
    }
    
    func setAvatarPhotoImage(_ image: UIImage?) {
        avatarImageView.image = image ?? #imageLiteral(resourceName: "Avatar")
    }
    
    var onAddPhotoButtonTap: (() -> ())?
    
    // MARK: - Private
    @objc private func addPhotoPressed() {
        onAddPhotoButtonTap?()
    }
}
