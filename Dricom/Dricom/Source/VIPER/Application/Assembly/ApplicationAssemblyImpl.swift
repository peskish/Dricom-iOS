import UIKit

final class ApplicationAssemblyImpl: BaseAssembly, ApplicationAssembly {
    // MARK: - ApplicationAssembly
    func module() -> (rootViewController: UIViewController, applicationLaunchHandler: ApplicationLaunchHandler) {
        let tabBarController = ApplicationTabBarController()
        let viewControllers = [
            makeMainViewController(),
            UIViewController(),
            UIViewController(),
            UIViewController()
        ]
        tabBarController.viewControllers = viewControllers
        
        let interactor = ApplicationInteractorImpl()
        
        let router = ApplicationRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: tabBarController
        )
        
        let presenter = ApplicationPresenter(
            interactor: interactor,
            router: router
        )
        
        tabBarController.addDisposable(presenter)
        
        presenter.view = tabBarController
        
        return (rootViewController: tabBarController, applicationLaunchHandler: presenter)
    }
    
    // MARK: - Private
    private func makeMainViewController() -> UIViewController {
        let assembly = assemblyFactory.mainPageAssembly()
        let navigationController = UINavigationController(rootViewController: assembly.module())
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: #imageLiteral(resourceName: "TabMain"),
            selectedImage: #imageLiteral(resourceName: "TabMain")
        )
        return navigationController
    }
}
