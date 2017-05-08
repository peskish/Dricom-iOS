import UIKit

final class ChatAssemblyImpl: BaseAssembly, ChatAssembly {
    // MARK: - ChatAssembly
    func module(position: ViewControllerPosition) -> UIViewController
    {
        let interactor = ChatInteractorImpl()
        
        let viewController = ChatViewController(position: position)
        
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
        
        return viewController
    }
}
