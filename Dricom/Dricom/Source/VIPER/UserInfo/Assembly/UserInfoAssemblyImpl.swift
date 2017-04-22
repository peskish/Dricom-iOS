import UIKit

final class UserInfoAssemblyImpl: BaseAssembly, UserInfoAssembly {
    // MARK: - UserInfoAssembly
    func module(
        userInfo: UserInfo,
        configure: (_ module: UserInfoModule) -> ())
        -> UIViewController
    {
        let interactor = UserInfoInteractorImpl(
            userInfo: userInfo,
            favoriteUsersService: serviceFactory.favoriteUsersService()
        )
        
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
