import UIKit

final class MainPageAssemblyImpl: BaseAssembly, MainPageAssembly {
    // MARK: - MainPageAssembly
    func module(user: User) -> UIViewController
    {
        let interactor = MainPageInteractorImpl(user: user)
        
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
        
        return viewController
    }
}
