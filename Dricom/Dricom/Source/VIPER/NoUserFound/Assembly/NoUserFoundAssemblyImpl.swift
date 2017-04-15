import UIKit

final class NoUserFoundAssemblyImpl: BaseAssembly, NoUserFoundAssembly {
    // MARK: - NoUserFoundAssembly
    func module() -> UIViewController
    {
        let viewController = NoUserFoundViewController()
        
        let router = NoUserFoundRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: viewController
        )
        
        let presenter = NoUserFoundPresenter(
            router: router
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
