import UIKit

final class UserInfoAssemblyImpl: BaseAssembly, UserInfoAssembly {
    // MARK: - UserInfoAssembly
    func module(
        configure: (_ module: UserInfoModule) -> ())
        -> UIViewController
    {
        let interactor = UserInfoInteractorImpl()
        
        let viewController = UserInfoViewController()
        
        let router = UserInfoRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: viewController
        )
        
        let presenter = UserInfoPresenter(
            interactor: interactor,
            router: router
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        configure(presenter)
        
        return viewController
    }
}
