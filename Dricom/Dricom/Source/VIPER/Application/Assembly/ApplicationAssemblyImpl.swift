import UIKit

final class ApplicationAssemblyImpl: BaseAssembly, ApplicationAssembly {
    // MARK: - ApplicationAssembly
    func module() -> (rootViewController: UIViewController?, applicationEventsHandler: ApplicationEventsHandler?)
    {
        // Splash screen
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: Bundle.main)
        guard let viewController = storyboard.instantiateInitialViewController() else {
            assertionFailure("Can't create splash view controller from LaunchScreen storyboard")
            return (rootViewController: nil, applicationEventsHandler: nil)
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let interactor = ApplicationInteractorImpl()
        let router = ApplicationRouterImpl(assemblyFactory: assemblyFactory)
        let presenter = ApplicationPresenter(
            interactor: interactor,
            router: router
        )
        
        return (rootViewController: navigationController, applicationEventsHandler: presenter)
    }
}
