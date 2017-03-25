import UIKit

final class UserProfileAssemblyImpl: BaseAssembly, UserProfileAssembly {
    // MARK: - UserProfileAssembly
    func module() -> UIViewController {
        let interactor = UserProfileInteractorImpl(
            userDataService: serviceFactory.userDataService(),
            dataValidationService: serviceFactory.dataValidationService()
        )
        
        let viewController = UserProfileViewController()
        
        let router = UserProfileRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: viewController
        )
        
        let presenter = UserProfilePresenter(
            interactor: interactor,
            router: router
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        return viewController
    }
}
