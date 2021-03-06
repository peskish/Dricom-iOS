import UIKit

final class RegisterAssemblyImpl: BaseAssembly, RegisterAssembly {
    // MARK: - RegisterAssembly
    func module(
        configure: (_ module: RegisterModule) -> ())
        -> UIViewController
    {
        let interactor = RegisterInteractorImpl(
            dataValidationService: serviceFactory.dataValidationService(),
            registrationService: serviceFactory.registrationService()
        )
        
        let viewController = RegisterViewController()
        
        let router = RegisterRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: viewController
        )
        
        let presenter = RegisterPresenter(
            interactor: interactor,
            router: router
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        configure(presenter)
        
        return viewController
    }
}
