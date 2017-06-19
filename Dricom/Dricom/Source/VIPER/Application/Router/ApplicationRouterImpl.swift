import UIKit

final class ApplicationRouterImpl: BaseRouter, ApplicationRouter, RouterLoginShowable {
    // MARK: - ApplicationRouter
    func showAppStarter(
        disposeBag: DisposeBag,
        completion: ((ApplicationLaunchHandler) -> ())?)
    {
        let assembly = assemblyFactory.appStarterAssembly()
        let module = assembly.module(disposeBag: disposeBag)
        
        module.viewController.modalTransitionStyle = .crossDissolve
        module.viewController.modalPresentationStyle = .fullScreen
        viewController?.present(module.viewController, animated: false) {
            completion?(module.applicationLaunchHandler)
        }
    }
    
    func showLogin(configure: (_ module: LoginModule) -> ()) {
        showLogin(
            configure: configure,
            animated: true,
            modalTransitionStyle: nil,
            modalPresentationStyle: nil
        )
    }
}
