import UIKit

final class ChatAssemblyImpl: BaseAssembly, ChatAssembly {
    // MARK: - ChatAssembly
    func module(channel: Channel, position: ViewControllerPosition) -> UIViewController {
        let interactor = ChatInteractorImpl(channel: channel, chatService: serviceFactory.chatService())
        
        let viewController = ChatViewController(
            position: position,
            user: channel.user,
            collocutor: channel.collocutor
        )
        
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
