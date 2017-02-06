import UIKit

final class AppStarterRouterImpl: BaseRouter, AppStarterRouter {
    // MARK: - AppStarterRouter
    func showLogin(configure: (_ module: LoginModule) -> ()) {
        guard let viewController = viewController else {
            assertionFailure("viewController is nil")
            return
        }
        
        let assembly = assemblyFactory.loginAssembly()
        let targetViewController = assembly.module(configure: configure)
        let navigationController = UINavigationController(rootViewController: targetViewController)
        
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .overCurrentContext
        viewController.present(navigationController, animated: true, completion: nil)
    }
}
