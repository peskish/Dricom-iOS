import Foundation

protocol MainPageRouter: class, RouterFocusable, RouterDismissable {
    func showUser(_ user: User, configure: (_ module: UserInfoModule) -> ())
    func showNoUserFound()
}
