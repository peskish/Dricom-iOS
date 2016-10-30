import UIKit

final class ApplicationRouterImpl: BaseRouter, ApplicationRouter {
    // MARK: - ApplicationRouter
    func showLoginOrRegister(configure: (_ module: LoginOrRegisterModule) -> ()) {
        let assembly = assemblyFactory.loginOrRegisterAssembly()
        let targetViewController = assembly.module(configure: configure)
        navigationController?.pushViewController(targetViewController, animated: false)
    }
}
