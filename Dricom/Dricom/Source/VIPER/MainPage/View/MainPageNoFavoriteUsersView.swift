import UIKit

class MainPageNoFavoriteUsersView: UIView {
    // MARK: Properties
    private let imageView = UIImageView(image: #imageLiteral(resourceName: "No favorite users"))
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Style
    private func setStyle() {
        backgroundColor = .drcWhite
        
        titleLabel.font = SpecFonts.ralewayMedium(17)
        titleLabel.textColor = .drcSlate
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        descriptionLabel.font = SpecFonts.ralewayRegular(14)
        descriptionLabel.textColor = .drcCoolGrey
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.sizeToFit()
        imageView.centerX = bounds.centerX
        imageView.top = bounds.top
        
        titleLabel.sizeToFit()
        titleLabel.centerX = bounds.centerX
        titleLabel.top = imageView.bottom + 34
        
        descriptionLabel.sizeToFit()
        descriptionLabel.centerX = bounds.centerX
        descriptionLabel.top = titleLabel.bottom + 15
    }
    
    // MARK: - Content
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setDescription(_ text: String) {
        descriptionLabel.text = text
    }
}
