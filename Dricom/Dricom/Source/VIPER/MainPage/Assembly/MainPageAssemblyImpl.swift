import UIKit

final class MainPageAssemblyImpl: BaseAssembly, MainPageAssembly {
    // MARK: - MainPageAssembly
    func module() -> (viewController: UIViewController, interface: MainPageModule)
    {
        let interactor = MainPageInteractorImpl(
            userDataService: serviceFactory.userDataService(),
            userSearchService: serviceFactory.userSearchService(),
            favoriteUsersService: serviceFactory.favoriteUsersService()
        )
        
        let viewController = MainPageViewController()
        
        let router = MainPageRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: viewController
        )
        
        let presenter = MainPagePresenter(
            interactor: interactor,
            router: router
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        let _ = viewController.view
        
        return (viewController: viewController, interface: presenter)
    }
}
