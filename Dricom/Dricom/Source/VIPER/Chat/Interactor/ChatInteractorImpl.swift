import Foundation

final class ChatInteractorImpl: ChatInteractor {
    // MARK: - Dependencies
    private let chatService: ChatService
    
    // MARK: - Properties
    private let channel: Channel
    private lazy var newMessagesPollingService: CommonPollingService = {
        return CommonPollingService(
            pollingInterval: 10,
            shouldStartPollingAndFireOnInitialApplicationActivation: false,
            pollingAction: { [weak self] in
                guard let `self` = self else { return }
                
                self.chatService.messages(channelId: self.channel.id) { result in
                    result.onData { [weak self] messagesResult in
                        self?.onReceiveMessages?(messagesResult.results)
                    }
                }
            }
        )
    }()
    
    // MARK: - Init
    init(channel: Channel, chatService: ChatService) {
        self.channel = channel
        self.chatService = chatService
    }
    
    // MARK: - ChatInteractor
    func obtainChannel() -> Channel {
        return channel
    }
    
    func startMessagesPolling() {
        newMessagesPollingService.startPolling()
    }
    
    func send(_ text: String, completion: @escaping ApiResult<[TextMessage]>.Completion) {
        chatService.addTextMessage(channelId: channel.id, text: text) { [weak self] result in
            result.onData { addMessageResult in
                if addMessageResult.success {
                    self?.fetchMessages(completion: completion)
                } else {
                    completion(.error(NetworkRequestError.internalServerError))
                }
            }
            result.onError { networkRequestError in
                completion(.error(networkRequestError))
            }
        }
    }
    
    func fetchMessages(completion: @escaping ApiResult<[TextMessage]>.Completion) {
        chatService.messages(channelId: channel.id) { result in
            result.onData { messagesResult in
                completion(.data(messagesResult.results))
            }
            result.onError { networkRequestError in
                completion(.error(networkRequestError))
            }
        }
    }
    
    var onReceiveMessages: (([TextMessage]) -> ())?
}
