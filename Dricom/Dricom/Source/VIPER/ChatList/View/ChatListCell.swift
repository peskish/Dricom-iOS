import UIKit
import AlamofireImage

final class ChatListCell: UITableViewCell {
    // MARK: - Properties
    private let avatarSize = CGSize(width: 65, height: 65)
    private let userNameLabel = UILabel()
    private let avatarImageView = UIImageView(image: #imageLiteral(resourceName: "Avatar"))
    private let createdAtLabel = UILabel()
    private let messageLabel = UILabel()
    private let separatorView = UIView()
    
    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubview(avatarImageView)
        addSubview(userNameLabel)
        addSubview(messageLabel)
        addSubview(createdAtLabel)
        addSubview(separatorView)
        
        backgroundColor = .drcWhite
        separatorView.backgroundColor = .drcPaleGreyTwo
        
        selectionStyle = .gray
        
        avatarImageView.size = avatarSize
        avatarImageView.layer.cornerRadius = avatarImageView.size.height/2
        avatarImageView.layer.masksToBounds = true
        
        userNameLabel.font = UIFont.drcUserRowNameFont()
        userNameLabel.lineBreakMode = .byTruncatingTail
        userNameLabel.textColor = UIColor.drcSlate
        
        createdAtLabel.font = UIFont.drcCreatedAtFont()
        createdAtLabel.textColor = UIColor.drcSlate.withAlphaComponent(0.6)
        
        messageLabel.font = UIFont.drcUserRowLicenseFont()
        messageLabel.textColor = UIColor.drcSlate.withAlphaComponent(0.6)
        messageLabel.numberOfLines = 2
        messageLabel.lineBreakMode = .byTruncatingTail
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.centerY = bounds.centerY
        avatarImageView.left = 15
        
        createdAtLabel.sizeToFit()
        createdAtLabel.right = bounds.right - 15
        
        userNameLabel.sizeToFit()
        userNameLabel.layout(
            left: avatarImageView.right + 13,
            right: createdAtLabel.left - 5,
            top: 23,
            height: userNameLabel.size.height
        )
        
        createdAtLabel.bottom = userNameLabel.bottom

        messageLabel.sizeToFit()
        messageLabel.layout(
            left: userNameLabel.left,
            right: createdAtLabel.right,
            top: userNameLabel.bottom + 2,
            height: messageLabel.height
        )
        
        separatorView.layout(
            left: bounds.left,
            right: bounds.right,
            bottom: bounds.bottom,
            height: 1.0 / UIScreen.main.scale
        )
    }
    
    // MARK: - Content
    func setViewData(_ viewData: ChatListRowData) {
        setAvatarImageUrl(viewData.avatarImageUrl)
        userNameLabel.text = viewData.lastMessageUserName
        createdAtLabel.text = viewData.lastMessageCreatedAtText
        messageLabel.text = viewData.lastMessageCreatedAtText
    }
    
    private func setAvatarImageUrl(_ avatarImageUrl: URL?) {
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
}
