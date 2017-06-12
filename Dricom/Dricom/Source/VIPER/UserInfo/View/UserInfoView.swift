import UIKit
import AlamofireImage

final class UserInfoView: UIView, StandardPreloaderViewHolder, ActivityDisplayable {
    // MARK: Properties
    private let avatarImageView = UIImageView(image: #imageLiteral(resourceName: "Avatar"))
    private let licenceView = LicensePlateView()
    private let favoritesButton = UIButton(type: .custom)
    private let hintLabel = UILabel()
    private let sendMessageButton = ActionButtonView()
    private let callButton = ActionButtonView()
    
    let preloader = StandardPreloaderView(style: .dark)
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(avatarImageView)
        addSubview(licenceView)
        addSubview(favoritesButton)
        addSubview(hintLabel)
        addSubview(sendMessageButton)
        addSubview(callButton)
        
        addSubview(preloader)
        
        setUpStyle()
        
        favoritesButton.addTarget(self, action: #selector(favoritesButtonPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpStyle() {
        backgroundColor = UIColor.drcWhite
        
        avatarImageView.size = SpecSizes.avatarImageSize
        avatarImageView.layer.cornerRadius = avatarImageView.size.height/2
        avatarImageView.layer.masksToBounds = true
        
        favoritesButton.setImage(#imageLiteral(resourceName: "Add photo"), for: .normal)
        favoritesButton.adjustsImageWhenHighlighted = false
        favoritesButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        
        hintLabel.font = UIFont.drcUserHintFont()
        hintLabel.textColor = UIColor.drcSlate
        hintLabel.textAlignment = .center
        hintLabel.numberOfLines = 0
        
        sendMessageButton.style = .dark
        callButton.style = .dark
    }
    
    // MARK: - Layout
    private let favoritesButtonPadding: CGFloat = 29
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.top = bounds.top
        avatarImageView.centerX = bounds.centerX
        
        licenceView.size = licenceView.sizeThatFits()
        licenceView.top = avatarImageView.bottom + SpecMargins.contentMargin
        licenceView.centerX = bounds.centerX
        
        favoritesButton.sizeToFit()
        let sizeOfText = favoritesButton.titleLabel?.sizeThatFits() ?? .zero
        let sizeOfImage = favoritesButton.imageView?.sizeThatFits() ?? .zero
        favoritesButton.width = sizeOfText.width
            + sizeOfImage.width
            + favoritesButton.titleEdgeInsets.left
            + favoritesButton.titleEdgeInsets.right
        favoritesButton.top = licenceView.bottom + favoritesButtonPadding
        favoritesButton.centerX = bounds.centerX
        
        callButton.layout(
            left: bounds.left,
            right: bounds.right,
            bottom: bounds.bottom - SpecMargins.contentSidePadding,
            height: SpecSizes.actionButtonHeight
        )
        
        sendMessageButton.layout(
            left: bounds.left,
            right: bounds.right,
            bottom: callButton.top - SpecMargins.contentMargin,
            height: SpecSizes.actionButtonHeight
        )
        
        hintLabel.size = hintLabel.sizeThatFits(
            CGSize(width: bounds.width - (2 * SpecMargins.contentSidePadding), height: .greatestFiniteMagnitude)
        )
        hintLabel.centerX = bounds.centerX
        hintLabel.bottom = sendMessageButton.top - SpecMargins.contentMargin
        
        preloader.frame = bounds
    }
    
    // MARK: - Public
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
    
    func setLicenseParts(_ licenseParts: LicenseParts) {
        licenceView.setLicenseParts(licenseParts)
    }
    
    func setFavoritesButtonTitle(_ title: String) {
        var attributes: [String: Any] = [
            NSForegroundColorAttributeName: UIColor.drcBlue,
            NSFontAttributeName: UIFont.drcAddPhotoFont() ?? .systemFont(ofSize: 15)
        ]
        let normalTitle = NSAttributedString(string: title, attributes: attributes)
        
        attributes[NSForegroundColorAttributeName] = UIColor.drcWarmBlue
        let highlightedTitle = NSAttributedString(string: title, attributes: attributes)
        
        favoritesButton.setAttributedTitle(normalTitle, for: .normal)
        favoritesButton.setAttributedTitle(highlightedTitle, for: .highlighted)
        
        setNeedsLayout()
    }
    
    var onFavoritesButtonTap: (() -> ())?
    @objc private func favoritesButtonPressed() {
        onFavoritesButtonTap?()
    }
    
    func setUserConnectionHint(_ hint: String) {
        hintLabel.text = hint
        setNeedsLayout()
    }
    
    func setCallButtonTitle(_ title: String) {
        callButton.setTitle(title)
    }
    
    func setCallButtonEnabled(_ enabled: Bool) {
        callButton.setEnabled(enabled)
    }
    
    var onCallButtonTap: (() -> ())? {
        get { return callButton.onTap }
        set { callButton.onTap = newValue }
    }
    
    func setMessageButtonTitle(_ title: String) {
        sendMessageButton.setTitle(title)
    }
    
    func setMessageButtonEnabled(_ enabled: Bool) {
        sendMessageButton.setEnabled(enabled)
    }
    
    var onMessageButtonTap: (() -> ())? {
        get { return sendMessageButton.onTap }
        set { sendMessageButton.onTap = newValue }
    }
}
