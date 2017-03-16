import Foundation

protocol SettingsRouter: class, RouterFocusable, RouterDismissable {
    func showLogin(configure: (_ module: LoginModule) -> ())
}
