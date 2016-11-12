import UIKit

final class LoginRouterImpl: BaseRouter, LoginRouter {
    // MARK: - LoginRouter
    func showRegister(configure: (_ module: RegisterModule) -> ()) {
        let assembly = assemblyFactory.registerAssembly()
        let targetViewController = assembly.module(configure: configure)
        navigationController?.pushViewController(targetViewController, animated: true)
    }
}
