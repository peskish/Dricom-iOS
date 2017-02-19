import UIKit

final class AppStarterAssemblyImpl: BaseAssembly, AppStarterAssembly {
    // MARK: - AppStarterAssembly
    func module(disposeBag: DisposeBag, mainPageModule: MainPageModule?)
        -> (viewController: UIViewController, applicationLaunchHandler: ApplicationLaunchHandler) {
        // Splash screen
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: Bundle.main)
        
        let viewController = storyboard.instantiateInitialViewController()!
        
        let interactor = AppStarterInteractorImpl(userDataService: serviceFactory.userDataService())
        let router = AppStarterRouterImpl(assemblyFactory: assemblyFactory, viewController: viewController)
        let presenter = AppStarterPresenter(
            interactor: interactor,
            router: router
        )
        presenter.mainPageModule = mainPageModule
        
        disposeBag.addDisposable(presenter)
        
        return (viewController: viewController, applicationLaunchHandler: presenter)
    }
}
