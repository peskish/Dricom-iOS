import UIKit
import AlamofireImage

final class MainPageView: UIView, StandardPreloaderViewHolder, ActivityDisplayable {
    // MARK: Properties
    private let nameLabel = UILabel()
    private let avatarImageView = UIImageView(image: #imageLiteral(resourceName: "Avatar"))
    private let licenceView = LicensePlateView()
    private let licenseSearchInputField = TextFieldView()
    private let licenseSearchButton = ActionButtonView()
    
    let preloader = StandardPreloaderView(style: .dark)
    
    private let favoriteUserAvatarSize = SpecSizes.smallAvatarImageSize/SpecSizes.scale
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(nameLabel)
        addSubview(avatarImageView)
        addSubview(licenceView)
        addSubview(licenseSearchInputField)
        addSubview(licenseSearchButton)
        
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
        
        nameLabel.font = UIFont.drcUserNameFont()
        nameLabel.textColor = UIColor.drcSlate
        nameLabel.textAlignment = .center
        
        licenseSearchButton.style = .dark
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.sizeToFit()
        nameLabel.layout(left: bounds.left, right: bounds.right, top: bounds.top + 45, fitBottom: bounds.bottom)
        
        avatarImageView.top = nameLabel.bottom + SpecMargins.innerContentMargin
        avatarImageView.centerX = bounds.centerX
        
        licenceView.size = licenceView.sizeThatFits()
        licenceView.top = avatarImageView.bottom + SpecMargins.contentMargin
        licenceView.centerX = bounds.centerX
        
        licenseSearchButton.layout(
            left: bounds.left + SpecMargins.contentSidePadding,
            right: bounds.right - SpecMargins.contentSidePadding,
            bottom: bounds.bottom - 35,
            height: SpecSizes.actionButtonHeight
        )
        
        licenseSearchInputField.layout(
            left: bounds.left,
            right: bounds.right,
            bottom: licenseSearchButton.top - 15,
            height: SpecSizes.inputFieldHeight
        )
    }
    
    // MARK: Public
    func setName(_ name: String?) {
        nameLabel.text = name
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
    
    func setLicenseParts(_ licenseParts: LicenseParts) {
        licenceView.setLicenseParts(licenseParts)
    }
    
    func setLicenseSearchPlaceholder(_ placeholder: String?) {
        licenseSearchInputField.placeholder = placeholder
    }
    
    var onLicenseSearchChange: ((String?) -> ())? {
        get { return licenseSearchInputField.onTextChange }
        set { licenseSearchInputField.onTextChange = newValue }
    }
    
    func setLicenseSearchTitle(_ title: String) {
        licenseSearchButton.setTitle(title)
    }
    
    func setOnSearchButtonTap(_ onSearchButtonTap: ((String?) -> ())?) {
        licenseSearchButton.onTap = { [licenseSearchInputField] in
            onSearchButtonTap?(licenseSearchInputField.text)
        }
    }
}
