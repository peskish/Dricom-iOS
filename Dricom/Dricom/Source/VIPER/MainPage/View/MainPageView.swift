import UIKit
import AlamofireImage

final class MainPageView: UIView, StandardPreloaderViewHolder, ActivityDisplayable {
    // MARK: Properties
    private let backgroundView = RadialGradientView()
    private let avatarImageView = UIImageView(image: UIImage(named: "No photo"))
    private let nameLabel = UILabel()
    private let licenceLabel = UILabel()
    private let favoriteUserAvatar1: ImageButtonView
    private let favoriteUserAvatar2: ImageButtonView
    private let favoriteUserAvatar3: ImageButtonView
    private let favoriteUserAvatar4: ImageButtonView
    private let favoriteUserAvatar5: ImageButtonView
    private let licenseSearchInputField = TextFieldView()
    private let licenseSearchButton = ActionButtonView()
    private let infoButtonView = ImageButtonView(image: UIImage(named: "Info sign"))
    
    let preloader = StandardPreloaderView(style: .dark)
    
    private let favoriteUserAvatarSize = SpecSizes.smallAvatarImageSize/SpecSizes.scale
    
    // MARK: - Init
    init() {
        
        favoriteUserAvatar1 = ImageButtonView(image: nil, customSize: favoriteUserAvatarSize)
        favoriteUserAvatar2 = ImageButtonView(image: nil, customSize: favoriteUserAvatarSize)
        favoriteUserAvatar3 = ImageButtonView(image: nil, customSize: favoriteUserAvatarSize)
        favoriteUserAvatar4 = ImageButtonView(image: nil, customSize: favoriteUserAvatarSize)
        favoriteUserAvatar5 = ImageButtonView(image: nil, customSize: favoriteUserAvatarSize)
        
        super.init(frame: .zero)
        
        addSubview(backgroundView)
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(licenceLabel)
        addSubview(favoriteUserAvatar1)
        addSubview(favoriteUserAvatar2)
        addSubview(favoriteUserAvatar3)
        addSubview(favoriteUserAvatar4)
        addSubview(favoriteUserAvatar5)
        addSubview(licenseSearchInputField)
        addSubview(licenseSearchButton)
        addSubview(infoButtonView)
        
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Style
    private func setStyle() {
        backgroundColor = SpecColors.Background.defaultEdge
        
        avatarImageView.size = SpecSizes.avatarImageSize/SpecSizes.scale
        avatarImageView.layer.cornerRadius = avatarImageView.size.width/2
        avatarImageView.layer.masksToBounds = true
        
        [favoriteUserAvatar1,
         favoriteUserAvatar2,
         favoriteUserAvatar3,
         favoriteUserAvatar4,
         favoriteUserAvatar5]
            .forEach {
                $0.size = favoriteUserAvatarSize
                $0.layer.cornerRadius = self.favoriteUserAvatarSize.width/2
                $0.layer.masksToBounds = true
                $0.backgroundColor = SpecColors.Background.defaultEdge
                $0.layer.borderColor = UIColor.white.cgColor
                $0.layer.borderWidth = 1
            }
        
        [nameLabel, licenceLabel].forEach {
            $0.backgroundColor = .clear
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = SpecColors.textMain
            $0.textAlignment = .center
        }
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.top = SpecSizes.statusBarHeight * 3
        avatarImageView.centerX = bounds.centerX
        
        [favoriteUserAvatar1,
         favoriteUserAvatar2,
         favoriteUserAvatar3,
         favoriteUserAvatar4,
         favoriteUserAvatar5]
            .forEach{ $0.top = avatarImageView.bottom + SpecMargins.contentMargin }
        
        favoriteUserAvatar3.centerX = bounds.centerX
        favoriteUserAvatar2.right = favoriteUserAvatar3.left - SpecMargins.contentMargin
        favoriteUserAvatar1.right = favoriteUserAvatar2.left - SpecMargins.contentMargin
        favoriteUserAvatar4.left = favoriteUserAvatar3.right + SpecMargins.contentMargin
        favoriteUserAvatar5.left = favoriteUserAvatar4.right + SpecMargins.contentMargin
    }
    
    // MARK: Public
    func setAvatarImageUrl(_ avatarImageUrl: URL?) {
        guard let avatarImageUrl = avatarImageUrl
            else { return }
        
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
