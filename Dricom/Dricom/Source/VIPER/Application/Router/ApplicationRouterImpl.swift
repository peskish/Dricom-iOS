import UIKit

final class ApplicationRouterImpl: BaseRouter, ApplicationRouter {
    // MARK: - ApplicationRouter
    func showAppStarter(
        disposeBag: DisposeBag,
        mainPageModule: MainPageModule?,
        completion: ((ApplicationLaunchHandler) -> ())?)
    {
        let assembly = assemblyFactory.appStarterAssembly()
        let module = assembly.module(disposeBag: disposeBag, mainPageModule: mainPageModule)
        
        viewController?.present(module.viewController, animated: false) {
            completion?(module.applicationLaunchHandler)
        }
    }
}
