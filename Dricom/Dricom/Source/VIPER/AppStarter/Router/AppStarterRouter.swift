import Foundation

protocol AppStarterRouter: class, RouterFocusable, RouterDismissable {
    func showLogin(configure: (_ module: LoginModule) -> ())
}
