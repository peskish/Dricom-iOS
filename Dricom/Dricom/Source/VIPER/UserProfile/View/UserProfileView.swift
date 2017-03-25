import UIKit
import AlamofireImage

final class UserProfileView: UIView, ActivityDisplayable, StandardPreloaderViewHolder {
    let preloader = StandardPreloaderView(style: .dark)
    
    private let changePhotoButton = UIButton(type: .custom)
    private let avatarImageView = UIImageView(image: #imageLiteral(resourceName: "Avatar"))
    private let avatarTapGesture = UITapGestureRecognizer(
        target: self,
        action: #selector(changePhotoPressed)
    )
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(preloader)
        
        addSubview(changePhotoButton)
        addSubview(avatarImageView)
        
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
        
        avatarImageView.sizeToFit()
        avatarImageView.centerX = bounds.centerX
        avatarImageView.top = bounds.top + 15
        
        changePhotoButton.sizeToFit()
        changePhotoButton.top = avatarImageView.bottom + 10
        changePhotoButton.centerX = bounds.centerX
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
        // TODO:
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
}
