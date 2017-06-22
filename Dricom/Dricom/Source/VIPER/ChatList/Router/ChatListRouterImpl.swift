import UIKit

final class ChatListRouterImpl: BaseRouter, ChatListRouter {
    // MARK: - ChatListRouter
    func openChannel(_ channel: Channel) {
        let assembly = assemblyFactory.chatAssembly()
        let targetViewController = assembly.module(channel: channel, position: .pushed)
        viewController?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(targetViewController, animated: true)
        viewController?.hidesBottomBarWhenPushed = false
    }
}
