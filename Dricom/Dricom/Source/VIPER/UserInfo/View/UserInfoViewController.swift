import UIKit

final class UserInfoViewController: BaseViewController, UserInfoViewInput {
    
    // MARK: - Properties
    private let userInfoView = UserInfoView()
    
    // MARK: - View lifecycle
    override func loadView() {
        view = userInfoView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setStyle(.main)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - UserInfoViewInput
    func setName(_ name: String?) {
        title = name
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
    
    func setCallButtonEnabled(_ enabled: Bool) {
        userInfoView.setCallButtonEnabled(enabled)
    }
    
    var onCallButtonTap: (() -> ())? {
        get { return userInfoView.onCallButtonTap }
        set { userInfoView.onCallButtonTap = newValue }
    }
    
    func setMessageButtonTitle(_ title: String) {
        userInfoView.setMessageButtonTitle(title)
    }
    
    func setMessageButtonEnabled(_ enabled: Bool) {
        userInfoView.setMessageButtonEnabled(enabled)
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
