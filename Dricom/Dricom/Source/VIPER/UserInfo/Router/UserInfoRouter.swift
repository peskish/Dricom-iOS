import Foundation

protocol UserInfoRouter: class, RouterFocusable, RouterDismissable {
    func openChannel(_ channel: Channel)
}
