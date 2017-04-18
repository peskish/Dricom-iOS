import UIKit

final class MainPageRouterImpl: BaseRouter, MainPageRouter {
    // MARK: - MainPageRouter
    func showUserInfo(_ userInfo: UserInfo, configure: (_ module: UserInfoModule) -> ()) {
        let assembly = assemblyFactory.userInfoAssembly()
        let targetViewController = assembly.module(userInfo: userInfo, configure: configure)
        targetViewController.modalTransitionStyle = .crossDissolve
        viewController?.present(targetViewController, animated: true, completion: nil)
    }
    
    func showNoUserFound() {
        let assembly = assemblyFactory.noUserFoundAssembly()
        let targetViewController = assembly.module()
        targetViewController.modalTransitionStyle = .crossDissolve
        viewController?.present(targetViewController, animated: true, completion: nil)
    }
}
