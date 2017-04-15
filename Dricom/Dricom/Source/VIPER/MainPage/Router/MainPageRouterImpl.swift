import UIKit

final class MainPageRouterImpl: BaseRouter, MainPageRouter {
    // MARK: - MainPageRouter
    func showUser(_ user: User) {
        print("showUser")
    }
    
    func showNoUserFound() {
        print("showNoUserFound")
    }
}
