import UIKit

final class MainPageRouterImpl: BaseRouter, MainPageRouter {
    // MARK: - MainPageRouter
    func showUserInfo(_ userInfo: UserInfo, configure: (_ module: UserInfoModule) -> ()) {
        let assembly = assemblyFactory.userInfoAssembly()
        let targetViewController = assembly.module(userInfo: userInfo, configure: configure)
        viewController?.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(targetViewController, animated: true)
        viewController?.hidesBottomBarWhenPushed = false
    }
}
