import UIKit
import AlamofireImage

final class MainPageView: UIScrollView, StandardPreloaderViewHolder, ActivityDisplayable {
    // MARK: Properties
    private let nameLabel = UILabel()
    private let avatarImageView = UIImageView(image: #imageLiteral(resourceName: "Avatar"))
    private let licenceView = LicensePlateView()
    private let licenseSearchInputField = TextFieldView()
    private let licenseSearchButton = ActionButtonView()
    
    let preloader = StandardPreloaderView(style: .dark)
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        bounces = false
        
        addSubview(nameLabel)
        addSubview(avatarImageView)
        addSubview(licenceView)
        addSubview(licenseSearchInputField)
        addSubview(licenseSearchButton)
        
        licenseSearchButton.setImage(#imageLiteral(resourceName: "Loupe"), forState: .normal)
        
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Style
    private func setStyle() {
        backgroundColor = UIColor.drcWhite
        
        avatarImageView.size = SpecSizes.avatarImageSize
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
        nameLabel.layout(left: bounds.left, right: bounds.right, top: 45, height: nameLabel.height)
        
        avatarImageView.top = nameLabel.bottom + SpecMargins.innerContentMargin
        avatarImageView.centerX = bounds.centerX
        
        licenceView.size = licenceView.sizeThatFits()
        licenceView.top = avatarImageView.bottom + SpecMargins.contentMargin
        licenceView.centerX = bounds.centerX
        
        licenseSearchInputField.layout(
            left: bounds.left,
            right: bounds.right,
            top: licenceView.bottom + SpecMargins.contentMargin,
            height: SpecSizes.inputFieldHeight
        )
        
        licenseSearchButton.layout(
            left: bounds.left,
            right: bounds.right,
            top: licenseSearchInputField.bottom + SpecMargins.inputAndButtonMargin,
            height: SpecSizes.actionButtonHeight
        )
    }
    
    // MARK: Public
    func setName(_ name: String?) {
        nameLabel.text = name
        setNeedsLayout()
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
