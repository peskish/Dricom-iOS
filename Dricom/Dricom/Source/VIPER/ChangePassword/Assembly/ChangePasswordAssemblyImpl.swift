import UIKit

final class ChangePasswordAssemblyImpl: BaseAssembly, ChangePasswordAssembly {
    // MARK: - ChangePasswordAssembly
    func module(
        configure: (_ module: ChangePasswordModule) -> ())
        -> UIViewController
    {
        let interactor = ChangePasswordInteractorImpl()
        
        let viewController = ChangePasswordViewController()
        
        let router = ChangePasswordRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: viewController
        )
        
        let presenter = ChangePasswordPresenter(
            interactor: interactor,
            router: router
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        configure(presenter)
        
        return viewController
    }
}
