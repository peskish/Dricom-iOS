import UIKit
import AlamofireImage

class MainPageAccountView: UIView {
    // MARK: Properties
    private let nameLabel = UILabel()
    private let avatarImageView = UIImageView(image: #imageLiteral(resourceName: "Avatar"))
    private let licenseLabel = UILabel()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(nameLabel)
        addSubview(avatarImageView)
        addSubview(licenseLabel)
        
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Style
    private func setStyle() {
        backgroundColor = UIColor.drcWhite
        
        avatarImageView.size = #imageLiteral(resourceName: "Avatar").size
        avatarImageView.layer.cornerRadius = avatarImageView.size.height/2
        avatarImageView.layer.masksToBounds = true
        
        nameLabel.font = SpecFonts.ralewayMedium(21)
        nameLabel.textColor = UIColor.drcSlate
        
        licenseLabel.font = SpecFonts.ralewayRegular(14)
        licenseLabel.textColor = UIColor.drcSlate.withAlphaComponent(0.6)
    }
    
    // MARK: Layout
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 110)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.centerY = bounds.centerY
        avatarImageView.left = SpecMargins.contentMargin
        
        nameLabel.sizeToFit()
        nameLabel.layout(
            left: avatarImageView.right + SpecMargins.innerContentMargin,
            right: bounds.right - SpecMargins.contentMargin,
            top: 33,
            height: nameLabel.height
        )
        
        licenseLabel.sizeToFit()
        licenseLabel.layout(
            left: nameLabel.left,
            right: bounds.right - SpecMargins.contentMargin,
            top: nameLabel.bottom + 5,
            height: licenseLabel.height
        )
    }
    
    // MARK: - Content
    func setViewData(_ viewData: AccountViewData) {
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
