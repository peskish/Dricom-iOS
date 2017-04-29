protocol UserSearchService: class {
    func searchUsers(license: String, shouldCancelPrevious: Bool, completion: @escaping ApiResult<[User]>.Completion)
    func cancelCurrentSearch()
}

final class UserSearchServiceImpl: UserSearchService {
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    
    // MARK: - Init
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - State
    private var currentSearchTask: NetworkDataTask?
    
    // MARK: - UserSearchService
    func searchUsers(license: String, shouldCancelPrevious: Bool, completion: @escaping ApiResult<[User]>.Completion) {
        if shouldCancelPrevious {
            cancelCurrentSearch()
        }
        
        guard let normalizedLicense = LicenseNormalizer.normalize(license: license) else {
            completion(.data([]))
            return
        }
        
        let request = SearchUserRequest(license: normalizedLicense)
        
        currentSearchTask = networkClient.send(request: request) { result in
            result.onData { searchUserResult in
                completion(.data(searchUserResult.results))
            }
            result.onError { error in
                completion(.error(error))
            }
        }
    }
    
    func cancelCurrentSearch() {
        currentSearchTask?.cancel()
    }
}
