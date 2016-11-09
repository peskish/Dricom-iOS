import UIKit

final class LoginOrRegisterView: UIView {
    // MARK: Properties
    private let logoImageView = UIImageView(image: UIImage(named: "Logo"))
    private let backgroundView = RadialGradientView()
    private let loginButtonView = ActionButtonView()
    private let registerButtonView = ActionButtonView()
    private let infoButtonView = ImageButtonView(image: UIImage(named: "Info sign"))
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        addSubview(backgroundView)
        addSubview(logoImageView)
        addSubview(loginButtonView)
        addSubview(registerButtonView)
        addSubview(infoButtonView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = bounds
        
        // Logo image has strange size (too big) - i'll try to use the half of it for now
        guard let imageSize = logoImageView.image?.size else { return }
        
        logoImageView.size = CGSize(width: imageSize.width/2, height: imageSize.height/2)
        logoImageView.top = SpecSizes.statusBarHeight * 2
        logoImageView.centerX = bounds.centerX
        
        infoButtonView.size = infoButtonView.sizeThatFits(bounds.size)
        infoButtonView.layout(right: bounds.right, bottom: bounds.bottom)
        
        let tabBarArea = CGRect(
            left: bounds.left,
            right: bounds.right,
            bottom: bounds.bottom,
            height: SpecSizes.bottomAreaHeight
        )
            
        registerButtonView.layout(
            left: bounds.left,
            bottom: tabBarArea.top - SpecMargins.contentMargin,
            fitWidth: bounds.width,
            fitHeight: SpecMargins.actionButtonHeight
        )
        
        loginButtonView.layout(
            left: bounds.left,
            bottom: registerButtonView.top - SpecMargins.contentMargin,
            fitWidth: bounds.width,
            fitHeight: SpecMargins.actionButtonHeight
        )
    }
    
    // MARK: - Setup
    func setLoginButtonTitle(_ title: String) {
        loginButtonView.setTitle(title)
    }
    
    func setRegisterButtonTitle(_ title: String) {
        registerButtonView.setTitle(title)
    }
    
    // MARK: - Actions
    var onLoginButtonTap: (() -> ())? {
        get { return loginButtonView.onTap }
        set { loginButtonView.onTap = newValue }
    }
    var onRegisterButtonTap: (() -> ())? {
        get { return registerButtonView.onTap }
        set { registerButtonView.onTap = newValue }
    }
    var onInfoButtonTap: (() -> ())? {
        get { return infoButtonView.onTap }
        set { infoButtonView.onTap = newValue }
    }
}
