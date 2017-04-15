import UIKit

final class UserInfoView: UIView, StandardPreloaderViewHolder, ActivityDisplayable {
    let preloader = StandardPreloaderView(style: .dark)
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        
        addSubview(preloader)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        preloader.frame = bounds
    }
    
    // MARK: - Public
    func setName(_ name: String?) {
        
    }
    
    func setAvatarImageUrl(_ avatarImageUrl: URL?) {
        
    }
    
    func setLicenseParts(_ licenseParts: LicenseParts) {
        
    }
    
    func setFavoritesButtonTitle(_ title: String) {
        
    }
    
    var onFavoritesButtonTap: (() -> ())?
    
    func setUserConnectionHint(_ hint: String) {
        
    }
    
    func setCallButtonTitle(_ title: String) {
        
    }
    
    var onCallButtonTap: (() -> ())?
    
    func setMessageButtonTitle(_ title: String) {
        
    }
    
    var onMessageButtonTap: (() -> ())?
}
