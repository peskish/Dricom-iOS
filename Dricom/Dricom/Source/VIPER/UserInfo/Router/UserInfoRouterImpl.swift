import UIKit

final class UserInfoRouterImpl: BaseRouter, UserInfoRouter {
    // MARK: - UserInfoRouter
    func openChannel(_ channel: Channel) {
        let assembly = assemblyFactory.chatAssembly()
        let targetViewController = assembly.module(channel: channel, position: .modal)
        let navigationController = UINavigationController(rootViewController: targetViewController)
        viewController?.present(navigationController, animated: true, completion: nil)
    }
}
