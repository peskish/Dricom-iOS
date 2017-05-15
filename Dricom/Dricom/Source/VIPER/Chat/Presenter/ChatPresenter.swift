import Foundation
import JSQMessagesViewController

final class ChatPresenter {
    // MARK: - Private properties
    private let interactor: ChatInteractor
    private let router: ChatRouter
    
    // MARK: - Init
    init(interactor: ChatInteractor,
         router: ChatRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: ChatViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        view?.onViewDidLoad = { [weak self] in
            self?.fetchAndPresentData()
        }
    }
    
    private func fetchAndPresentData() {
        let channel = interactor.obtainChannel()
        view?.setChannelInfo(
            ChannelInfo(
                collocutorName: channel.collocutor.name ?? "",
                ownerId: channel.user.id,
                ownerName: channel.user.name ?? ""
            )
        )
        
        interactor.messages { [weak self] result in
            result.onData { messageList in
                self?.view?.setMessages(
                    messageList.map { $0.toJSQMessage() }
                )
            }
            result.onError { networkRequestError in
                self?.view?.showError(networkRequestError)
            }
        }
    }
    
    // MARK: - ChatModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
}
