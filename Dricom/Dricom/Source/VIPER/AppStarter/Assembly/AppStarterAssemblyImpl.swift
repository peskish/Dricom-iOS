import UIKit

final class AppStarterAssemblyImpl: BaseAssembly, AppStarterAssembly {
    // MARK: - AppStarterAssembly
    func module(disposeBag: DisposeBag)
        -> (viewController: UIViewController, applicationLaunchHandler: ApplicationLaunchHandler) {
        // Splash screen
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: Bundle.main)
        
        let viewController = storyboard.instantiateInitialViewController()!
        
        let interactor = AppStarterInteractorImpl()
        let router = AppStarterRouterImpl(assemblyFactory: assemblyFactory, viewController: viewController)
        let presenter = AppStarterPresenter(
            interactor: interactor,
            router: router
        )
        
        disposeBag.addDisposable(presenter)
        
        return (viewController: viewController, applicationLaunchHandler: presenter)
    }
}
