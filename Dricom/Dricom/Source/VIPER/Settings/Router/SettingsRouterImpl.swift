import UIKit

final class SettingsRouterImpl: BaseRouter, SettingsRouter {
    // MARK: - SettingsRouter
    func showUserProfile() {
        let assembly = assemblyFactory.userProfileAssembly()
        let targetViewController = assembly.module()
        let navigationController = UINavigationController(rootViewController: targetViewController)
        viewController?.present(navigationController, animated: true, completion: nil)
    }
    
    func showChangePassword(configure: (_ module: ChangePasswordModule) -> ()) {
        let assembly = assemblyFactory.changePasswordAssembly()
        let targetViewController = assembly.module(configure: configure)
        let navigationController = UINavigationController(rootViewController: targetViewController)
        viewController?.present(navigationController, animated: true, completion: nil)
    }
}
