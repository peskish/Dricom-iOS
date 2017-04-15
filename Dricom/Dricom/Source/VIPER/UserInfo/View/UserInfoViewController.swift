import UIKit

final class UserInfoViewController: BaseViewController, UserInfoViewInput {
    private let userInfoView = UserInfoView()
    
    override func loadView() {
        view = userInfoView
    }
    
    // MARK: - UserInfoViewInput
    func setName(_ name: String?) {
        userInfoView.setName(name)
    }
    
    func setAvatarImageUrl(_ avatarImageUrl: URL?) {
        userInfoView.setAvatarImageUrl(avatarImageUrl)
    }
    
    func setLicenseParts(_ licenseParts: LicenseParts) {
        userInfoView.setLicenseParts(licenseParts)
    }
    
    func setFavoritesButtonTitle(_ title: String) {
        userInfoView.setFavoritesButtonTitle(title)
    }
    
    var onFavoritesButtonTap: (() -> ())? {
        get { return userInfoView.onFavoritesButtonTap }
        set { userInfoView.onFavoritesButtonTap = newValue }
    }
    
    func setUserConnectionHint(_ hint: String) {
        userInfoView.setUserConnectionHint(hint)
    }
    
    func setCallButtonTitle(_ title: String) {
        userInfoView.setCallButtonTitle(title)
    }
    
    var onCallButtonTap: (() -> ())? {
        get { return userInfoView.onCallButtonTap }
        set { userInfoView.onCallButtonTap = newValue }
    }
    
    func setMessageButtonTitle(_ title: String) {
        userInfoView.setMessageButtonTitle(title)
    }
    
    var onMessageButtonTap: (() -> ())? {
        get { return userInfoView.onMessageButtonTap }
        set { userInfoView.onMessageButtonTap = newValue }
    }
    
    // MARK: ActivityDisplayable
    func startActivity() {
        userInfoView.startActivity()
    }
    
    func stopActivity() {
        userInfoView.stopActivity()
    }
}
