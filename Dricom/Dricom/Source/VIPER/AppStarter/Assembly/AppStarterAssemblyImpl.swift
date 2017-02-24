import UIKit

final class AppStarterAssemblyImpl: BaseAssembly, AppStarterAssembly {
    // MARK: - AppStarterAssembly
    func module(disposeBag: DisposeBag, userSettable: UserSettable?)
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
        presenter.userSettable = userSettable
        
        disposeBag.addDisposable(presenter)
        
        return (viewController: viewController, applicationLaunchHandler: presenter)
    }
}
