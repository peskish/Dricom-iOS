import UIKit

final class SettingsRouterImpl: BaseRouter, SettingsRouter, RouterLoginShowable {
    // MARK: - SettingsRouter
    func showLogin(configure: (_ module: LoginModule) -> ()) {
        showLogin(
            configure: configure,
            animated: true,
            modalTransitionStyle: nil,
            modalPresentationStyle: nil
        )
    }
    
    func showUserProfile() {
        let assembly = assemblyFactory.userProfileAssembly()
        let targetViewController = assembly.module()
        navigationController?.pushViewController(targetViewController, animated: true)
    }
}
