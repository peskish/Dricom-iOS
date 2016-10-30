import UIKit

final class LoginOrRegisterAssemblyImpl: BaseAssembly, LoginOrRegisterAssembly {
    // MARK: - LoginOrRegisterAssembly
    func module(
        configure: (_ module: LoginOrRegisterModule) -> ())
        -> UIViewController
    {
        let viewController = LoginOrRegisterViewController()
        
        let router = LoginOrRegisterRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: viewController
        )
        
        let presenter = LoginOrRegisterPresenter(
            router: router
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        configure(presenter)
        
        return viewController
    }
}
