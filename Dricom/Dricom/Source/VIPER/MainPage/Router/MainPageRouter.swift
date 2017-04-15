import Foundation

protocol MainPageRouter: class, RouterFocusable, RouterDismissable {
    func showUser(_ user: User)
    func showNoUserFound()
}
