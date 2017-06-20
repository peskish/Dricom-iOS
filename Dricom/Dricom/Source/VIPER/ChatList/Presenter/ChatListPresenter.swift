import Foundation
import JSQMessagesViewController

final class ChatListPresenter:
    ChatListModule
{
    // MARK: - Private properties
    private let interactor: ChatListInteractor
    private let router: ChatListRouter
    
    // MARK: - Init
    init(interactor: ChatListInteractor,
         router: ChatListRouter)
    {
        self.interactor = interactor
        self.router = router
        
        setUpInteractor()
    }
    
    // MARK: - Weak properties
    weak var view: ChatListViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        view?.setViewTitle("Разговоры")
    }
    
    private func setUpInteractor() {
        interactor.onAccountDataReceived = { [weak self] _ in
            self?.interactor.chatList { result in
                result.onData { channelList in
                    guard let `self` = self else { return }
                    self.view?.setRowDataList(channelList.flatMap(self.makeChatListRowData))
                }
                result.onError { networkRequestError in
                    self?.view?.showError(networkRequestError)
                }
            }
        }
    }
    
    private func makeChatListRowData(_ channel: Channel) -> ChatListRowData {
        let lastMessageDate = channel.lastMessage?.createdAt.dateFromISO8601
        let lastMessageDateTimeText = lastMessageDate.flatMap { DateTimeFormatter.lastMessageDateTimeText($0) }
        
        return ChatListRowData(
            avatarImage: channel.user.avatar?.image,
            lastMessageUserName: channel.lastMessage?.owner.name,
            lastMessageText: channel.lastMessage?.text,
            lastMessageCreatedAtText: lastMessageDateTimeText,
            onTap: { [weak self] in
                // TODO: Open channel
            }
        )
    }
    
    // MARK: - ChatListModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    var onFinish: ((ChatListResult) -> ())?
}
