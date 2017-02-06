import UIKit

final class ApplicationRouterImpl: BaseRouter, ApplicationRouter {
    // MARK: - ApplicationRouter
    func showAppStarter(disposeBag: DisposeBag, completion: ((ApplicationLaunchHandler) -> ())?) {
        let assembly = assemblyFactory.appStarterAssembly()
        let module = assembly.module(disposeBag: disposeBag)
        
        viewController?.present(module.viewController, animated: false) {
            completion?(module.applicationLaunchHandler)
        }
    }
}
