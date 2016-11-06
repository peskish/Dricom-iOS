import UIKit

final class ApplicationRouterImpl: BaseRouter, ApplicationRouter {
    // MARK: - ApplicationRouter
    func showLoginOrRegister(configure: (_ module: LoginOrRegisterModule) -> ()) {
        guard let viewController = viewController else {
            assertionFailure("viewController is nil")
            return
        }
        
        let assembly = assemblyFactory.loginOrRegisterAssembly()
        let targetViewController = assembly.module(configure: configure)
        let _ = targetViewController.view
        let transition = CrossFadePushTransition()
        
        transition.animate(from: viewController, to: targetViewController) { [weak self] in
            self?.viewController?.navigationController?.viewControllers = [targetViewController]
            self?.viewController = targetViewController
        }
    }
    
    func showLogin(configure: (_ module: LoginModule) -> ()) {
        guard let navigationController = navigationController else {
            assertionFailure("navigationController is nil")
            return
        }
        
        let assembly = assemblyFactory.loginAssembly()
        let targetViewController = assembly.module(configure: configure)
        navigationController.pushViewController(targetViewController, animated: true)
    }
}
