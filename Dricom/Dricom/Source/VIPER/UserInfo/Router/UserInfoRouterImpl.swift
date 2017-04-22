import UIKit

final class UserInfoRouterImpl: BaseRouter, UserInfoRouter {
    // MARK: - UserInfoRouter
    func openChat(with user: User) {
        print("Open chat with: \(user.name)")
    }
}
