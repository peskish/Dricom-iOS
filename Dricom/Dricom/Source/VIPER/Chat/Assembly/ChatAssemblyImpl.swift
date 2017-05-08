import UIKit

final class ChatAssemblyImpl: BaseAssembly, ChatAssembly {
    // MARK: - ChatAssembly
    func module(
        configure: (_ module: ChatModule) -> ())
        -> UIViewController
    {
        let interactor = ChatInteractorImpl()
        
        let viewController = ChatViewController()
        
        let router = ChatRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: viewController
        )
        
        let presenter = ChatPresenter(
            interactor: interactor,
            router: router
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        configure(presenter)
        
        return viewController
    }
}
