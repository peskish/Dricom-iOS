protocol ChatCreationService: class {
    func createChat(userId: String, completion: @escaping ApiResult<CreateChannelResult>.Completion)
}

protocol MessengerService: ChatCreationService {
    func chatList(completion: @escaping ApiResult<ChannelsResult>.Completion)
}

final class MessengerServiceImpl: MessengerService {
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    
    // MARK: - Init
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - ChatCreationService
    func createChat(userId: String, completion: @escaping ApiResult<CreateChannelResult>.Completion) {
        let request = CreateChannelRequest(userId: userId)
        networkClient.send(request: request, completion: completion)
    }
    
    // MARK: - MessengerService
    func chatList(completion: @escaping ApiResult<ChannelsResult>.Completion) {
        let request = ChannelsRequest()
        networkClient.send(request: request, completion: completion)
    }
}
