import UIKit

final class AppStarterAssemblyImpl: BaseAssembly, AppStarterAssembly {
    // MARK: - AppStarterAssembly
    func module() -> (rootViewController: UIViewController?, starterModule: AppStarterModule?) {
        // Splash screen
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: Bundle.main)
        
        guard let viewController = storyboard.instantiateInitialViewController() else {
            assertionFailure("Can't create splash view controller from LaunchScreen storyboard")
            return (rootViewController: nil, starterModule: nil)
        }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let interactor = AppStarterInteractorImpl()
        let router = AppStarterRouterImpl(assemblyFactory: assemblyFactory, viewController: viewController)
        let presenter = AppStarterPresenter(
            interactor: interactor,
            router: router
        )
        
        return (rootViewController: navigationController, starterModule: presenter)
    }
}
