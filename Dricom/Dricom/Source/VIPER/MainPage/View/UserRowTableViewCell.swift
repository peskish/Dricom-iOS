import UIKit
import AlamofireImage

class UserRowTableViewCell: UITableViewCell {
    // MARK: - Properties
    private let avatarSize = CGSize(width: 50, height: 50)
    private let nameLabel = UILabel()
    private let avatarImageView = UIImageView(image: #imageLiteral(resourceName: "Avatar"))
    private let licenseLabel = UILabel()
    private let separatorView = UIView()
    
    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(licenseLabel)
        addSubview(separatorView)
        
        backgroundColor = .drcWhite
        separatorView.backgroundColor = .drcPaleGreyTwo
        
        selectionStyle = .gray
        
        avatarImageView.size = avatarSize
        avatarImageView.layer.cornerRadius = avatarImageView.size.height/2
        avatarImageView.layer.masksToBounds = true
        
        nameLabel.font = UIFont.drcUserRowNameFont()
        nameLabel.textColor = UIColor.drcSlate
        
        licenseLabel.font = UIFont.drcUserRowLicenseFont()
        licenseLabel.textColor = UIColor.drcSlate
        licenseLabel.alpha = 0.6
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
        avatarImageView.left = SpecMargins.contentMargin
        
        nameLabel.sizeToFit()
        nameLabel.layout(
            left: avatarImageView.right + SpecMargins.innerContentMargin,
            right: bounds.right - SpecMargins.contentMargin,
            top: 17,
            height: nameLabel.height
        )
        
        licenseLabel.sizeToFit()
        licenseLabel.layout(
            left: nameLabel.left,
            right: bounds.right - SpecMargins.contentMargin,
            top: nameLabel.bottom + 2,
            height: licenseLabel.height
        )
        
        separatorView.layout(
            left: nameLabel.left,
            right: bounds.right,
            bottom: bounds.bottom,
            height: 1.0 / UIScreen.main.scale
        )
    }
    
    // MARK: - Content
    func setViewData(_ viewData: UserRowViewData) {
        setName(viewData.name)
        setLicense(viewData.license)
        setAvatarImageUrl(viewData.avatarImageUrl)
    }
    
    private func setName(_ name: String?) {
        nameLabel.text = name
        setNeedsLayout()
    }
    
    private func setLicense(_ license: String?) {
        licenseLabel.text = license
        setNeedsLayout()
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
