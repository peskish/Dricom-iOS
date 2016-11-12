import UIKit

final class FeedbackView: UIView {
    private let logoImageView = UIImageView(image: UIImage(named: "Logo"))
    private let backgroundView = RadialGradientView()
    private let feedbackButton = ActionButtonView()
    private let supportButton = ActionButtonView()
    private let fbButtonView = ImageButtonView(image: UIImage(named: "Facebook"))
    private let vkButtonView = ImageButtonView(image: UIImage(named: "VKontakte"))
    private let instagramButtonView = ImageButtonView(image: UIImage(named: "Instagram"))
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(backgroundView)
        addSubview(logoImageView)
        addSubview(feedbackButton)
        addSubview(supportButton)
        addSubview(fbButtonView)
        addSubview(vkButtonView)
        addSubview(instagramButtonView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = bounds
        
        // Logo image has strange size (too big) - i'll try to use the half of it for now
        guard let imageSize = logoImageView.image?.size else { return }
        
        logoImageView.size = CGSize(width: imageSize.width/2, height: imageSize.height/2)
        logoImageView.top = SpecSizes.statusBarHeight * 2
        logoImageView.centerX = bounds.centerX
        
        let tabBarArea = CGRect(
            left: bounds.left,
            right: bounds.right,
            bottom: bounds.bottom,
            height: SpecSizes.bottomAreaHeight
        )
        
        supportButton.layout(
            left: bounds.left,
            bottom: tabBarArea.top - SpecMargins.contentMargin,
            fitWidth: bounds.width,
            fitHeight: SpecMargins.actionButtonHeight
        )
        
        feedbackButton.layout(
            left: bounds.left,
            bottom: supportButton.top - SpecMargins.contentMargin,
            fitWidth: bounds.width,
            fitHeight: SpecMargins.actionButtonHeight
        )
        
        for view in [fbButtonView, vkButtonView, instagramButtonView] {
            view.sizeToFit()
            view.centerY = bounds.centerY
        }
        
        vkButtonView.centerX = bounds.centerX
        instagramButtonView.centerX = bounds.width/4
        fbButtonView.centerX = bounds.width*3/4
    }
    
    // MARK: - Public
    func setFeedbackButtonTitle(_ title: String) {
        feedbackButton.setTitle(title)
    }
    
    func setSupportButtonTitle(_ title: String) {
        supportButton.setTitle(title)
    }
    
    var onFeedbackButtonTap: (() -> ())? {
        get { return feedbackButton.onTap }
        set { feedbackButton.onTap = newValue }
    }
    
    var onSupportButtonTap: (() -> ())? {
        get { return supportButton.onTap }
        set { supportButton.onTap = newValue }
    }
    
    var onFbButtonTap: (() -> ())? {
        get { return fbButtonView.onTap }
        set { fbButtonView.onTap = newValue }
    }
    
    var onVkButtonTap: (() -> ())? {
        get { return vkButtonView.onTap }
        set { vkButtonView.onTap = newValue }
    }
    
    var onInstagramButtonTap: (() -> ())? {
        get { return instagramButtonView.onTap }
        set { instagramButtonView.onTap = newValue }
    }
}
