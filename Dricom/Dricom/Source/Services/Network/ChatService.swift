protocol ChatService: class {
    func messages(channelId: String, completion: @escaping ApiResult<ChannelsResult>.Completion)
    
    func addTextMessage(
        channelId: String,
        text: String,
        completion: @escaping ApiResult<AddTextMessageResult>.Completion)
}

final class ChatServiceImpl: ChatService {
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    
    // MARK: - Init
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - ChatService
    func messages(channelId: String, completion: @escaping ApiResult<ChannelsResult>.Completion) {
        let request = ChannelMessagesRequest(channelId: channelId)
        networkClient.send(request: request, completion: completion)
    }
    
    func addTextMessage(
        channelId: String,
        text: String,
        completion: @escaping ApiResult<AddTextMessageResult>.Completion)
    {
        let request = AddTextMessageRequest(channelId: channelId, text: text)
        networkClient.send(request: request, completion: completion)
    }
}
