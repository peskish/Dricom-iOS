import Foundation

protocol AppStarterRouter: class, RouterFocusable, RouterDismissable {
    func showLogin(configure: (_ module: LoginModule) -> ())
    func showMainPage(user: User)
}
