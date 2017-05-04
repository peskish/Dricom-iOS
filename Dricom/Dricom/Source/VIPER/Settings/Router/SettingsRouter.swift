import Foundation

protocol SettingsRouter: class, RouterFocusable, RouterDismissable {
    func showLogin(configure: (_ module: LoginModule) -> ())
    func showUserProfile()
    func showChangePassword(configure: (_ module: ChangePasswordModule) -> ())
}
