import Foundation

protocol UserInfoRouter: class, RouterFocusable, RouterDismissable {
    func openChat(with user: User)
}
