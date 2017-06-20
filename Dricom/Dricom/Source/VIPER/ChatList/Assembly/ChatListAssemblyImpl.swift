import UIKit

final class ChatListAssemblyImpl: BaseAssembly, ChatListAssembly {
    // MARK: - ChatListAssembly
    func module(
        configure: (_ module: ChatListModule) -> ())
        -> UIViewController
    {
        let interactor = ChatListInteractorImpl(
            userDataObservable: serviceFactory.userDataObservable(),
            messengerService: serviceFactory.messengerService()
        )
        
        let viewController = ChatListViewController()
        
        let router = ChatListRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: viewController
        )
        
        let presenter = ChatListPresenter(
            interactor: interactor,
            router: router
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        configure(presenter)
        
        return viewController
    }
}
