import UIKit

final class ApplicationAssemblyImpl: BaseAssembly, ApplicationAssembly {
    // MARK: - ApplicationAssembly
    func module() -> (rootViewController: UIViewController, applicationLaunchHandler: ApplicationLaunchHandler) {
        let tabBarController = ApplicationTabBarController()
        
        let mainPageModule = assembleMainPageModule()
        
        let viewControllers = [
            mainPageModule.viewController,
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
        presenter.mainPageModule = mainPageModule.interface
        
        return (rootViewController: tabBarController, applicationLaunchHandler: presenter)
    }
    
    // MARK: - Private
    private func assembleMainPageModule() -> (viewController: UIViewController, interface: MainPageModule) {
        let assembly = assemblyFactory.mainPageAssembly()
        let module = assembly.module()
        let navigationController = UINavigationController(rootViewController: module.viewController)
        navigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: #imageLiteral(resourceName: "TabMain"),
            selectedImage: #imageLiteral(resourceName: "TabMainSelected")
        )
        return (viewController: navigationController, interface: module.interface)
    }
}
