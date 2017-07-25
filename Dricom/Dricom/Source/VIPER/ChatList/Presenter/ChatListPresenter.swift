import Foundation

final class ChatListPresenter: ChatListModule
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
        view?.setViewTitle("СООБЩЕНИЯ")
        
        view?.onPullToRefreshAction = { [weak self] in
            self?.reloadChatList()
        }
    }
    
    private func reloadChatList() {
        interactor.chatList { [weak self] result in
            self?.view?.endRefreshing()
            
            result.onData { channelList in
                guard let strongSelf = self else { return }
                if channelList.isEmpty {
                    strongSelf.view?.setState(
                        .empty(strongSelf.makeEmptyChatListRowData())
                    )
                } else {
                    strongSelf.view?.setState(
                        .data(channelList.flatMap(strongSelf.makeChatListRowData))
                    )
                }
            }
            result.onError { networkRequestError in
                self?.view?.showError(networkRequestError)
            }
        }
    }
    
    private func setUpInteractor() {
        interactor.onAccountDataReceived = { [weak self] _ in
            self?.reloadChatList()
        }
    }
    
    private func makeEmptyChatListRowData() -> ChatListEmptyRowData {
        return ChatListEmptyRowData(
            title: "У вас пока нет сообщений",
            message: "Найдите автовладельца через\n"
                + "поиск и напишите ему сообщение.\n"
                + "Новый разговор появится здесь."
        )
    }
    
    private func makeChatListRowData(_ channel: Channel) -> ChatListRowData {
        let lastMessageDate = channel.lastMessage?.createdAt.dateFromISO8601
        let lastMessageDateTimeText = lastMessageDate.flatMap { DateTimeFormatter.lastMessageDateTimeText($0) }
        
        return ChatListRowData(
            avatarImageUrl: channel.collocutor.avatar.flatMap{ URL(string: $0.image) },
            userName: channel.collocutor.name,
            messageText: channel.lastMessage?.text,
            createdAtText: lastMessageDateTimeText,
            onTap: { [weak self] in
                self?.router.openChannel(channel)
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
