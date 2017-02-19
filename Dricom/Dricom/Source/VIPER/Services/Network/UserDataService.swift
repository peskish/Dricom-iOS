protocol UserDataService: class {
    func user(completion: @escaping ApiResult<User>.Completion)
}

final class UserDataServiceImpl: UserDataService {
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    
    // MARK: - Init
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - UserDataService
    func user(completion: @escaping ApiResult<User>.Completion) {
        let request = AccountRequest()
        networkClient.send(request: request, completion: completion)
    }
}
