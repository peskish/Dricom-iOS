import Foundation

protocol UserInfoViewInput: class, ViewLifecycleObservable, MessageDisplayable, ActivityDisplayable {
    func setName(_ name: String?)
    func setAvatarImageUrl(_ avatarImageUrl: URL?)
    func setLicenseParts(_ licenseParts: LicenseParts)
    func setFavoritesButtonTitle(_ title: String)
    var onFavoritesButtonTap: (() -> ())? { get set }
    func setUserConnectionHint(_ hint: String)
    func setCallButtonTitle(_ title: String)
    var onCallButtonTap: (() -> ())? { get set }
    func setMessageButtonTitle(_ title: String)
    var onMessageButtonTap: (() -> ())? { get set }
}
