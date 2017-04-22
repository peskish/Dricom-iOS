import Foundation

protocol UserInfoViewInput: class, ViewLifecycleObservable, MessageDisplayable, ActivityDisplayable {
    func setName(_ name: String?)
    func setAvatarImageUrl(_ avatarImageUrl: URL?)
    func setLicenseParts(_ licenseParts: LicenseParts)
    func setFavoritesButtonTitle(_ title: String)
    var onFavoritesButtonTap: (() -> ())? { get set }
    func setUserConnectionHint(_ hint: String)
    func setCallButtonTitle(_ title: String)
    func setCallButtonEnabled(_ enabled: Bool)
    var onCallButtonTap: (() -> ())? { get set }
    func setMessageButtonTitle(_ title: String)
    func setMessageButtonEnabled(_ enabled: Bool)
    var onMessageButtonTap: (() -> ())? { get set }
    var onCloseTap: (() -> ())? { get set }
}
