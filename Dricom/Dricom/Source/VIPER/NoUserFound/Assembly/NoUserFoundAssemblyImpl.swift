import UIKit

final class NoUserFoundAssemblyImpl: BaseAssembly, NoUserFoundAssembly {
    // MARK: - NoUserFoundAssembly
    func module(
        configure: (_ module: NoUserFoundModule) -> ())
        -> UIViewController
    {
        let interactor = NoUserFoundInteractorImpl()
        
        let viewController = NoUserFoundViewController()
        
        let router = NoUserFoundRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: viewController
        )
        
        let presenter = NoUserFoundPresenter(
            interactor: interactor,
            router: router
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        configure(presenter)
        
        return viewController
    }
}
