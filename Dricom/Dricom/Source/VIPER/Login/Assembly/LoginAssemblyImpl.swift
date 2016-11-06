import UIKit

final class LoginAssemblyImpl: BaseAssembly, LoginAssembly {
    // MARK: - LoginAssembly
    func module(
        configure: (_ module: LoginModule) -> ())
        -> UIViewController
    {
        let interactor = LoginInteractorImpl()
        
        let viewController = LoginViewController()
        
        let router = LoginRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: viewController
        )
        
        let presenter = LoginPresenter(
            interactor: interactor,
            router: router
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        configure(presenter)
        
        return viewController
    }
}
