import Foundation

protocol ChatListRouter: class, RouterFocusable, RouterDismissable {
    func openChannel(_ channel: Channel)
}
