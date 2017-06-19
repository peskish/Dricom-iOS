import Foundation

protocol SettingsRouter: class, RouterFocusable, RouterDismissable {
    func showUserProfile()
    func showChangePassword(configure: (_ module: ChangePasswordModule) -> ())
}
