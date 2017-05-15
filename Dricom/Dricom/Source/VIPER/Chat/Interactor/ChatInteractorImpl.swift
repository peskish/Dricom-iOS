import Foundation

final class ChatInteractorImpl: ChatInteractor {
    // MARK: - Properties
    private let channel: Channel
    
    // MARK: - Dependencies
    private let chatService: ChatService
    
    // MARK: - Init
    init(channel: Channel, chatService: ChatService) {
        self.channel = channel
        self.chatService = chatService
    }
    
    // MARK: - ChatInteractor
    func obtainChannel() -> Channel {
        return channel
    }
    
    func messages(completion: @escaping ApiResult<[TextMessage]>.Completion) {
        chatService.messages(channelId: channel.id) { result in
            result.onData { messagesResult in
                completion(.data(messagesResult.results))
            }
            result.onError { networkRequestError in
                completion(.error(networkRequestError))
            }
        }
    }
}
