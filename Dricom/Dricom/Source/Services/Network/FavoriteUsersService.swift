protocol FavoriteUsersService: class {
    func addToFavorites(userId: String, completion: @escaping ApiResult<Bool>.Completion)
    func removeFromFavorites(userId: String, completion: @escaping ApiResult<Bool>.Completion)
    func favoritesList(completion: @escaping ApiResult<SearchUserResult>.Completion)
}

final class FavoriteUsersServiceImpl: FavoriteUsersService {
    // MARK: - Dependencies
    private let networkClient: NetworkClient
    
    // MARK: - Init
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - State
    private var currentFavoritesListTask: NetworkDataTask?
    
    // MARK: - FavoriteUsersService
    func addToFavorites(userId: String, completion: @escaping ApiResult<Bool>.Completion) {
        let request = AddUserToFavoritesRequest(userId: userId)
        networkClient.send(request: request) { result in
            result.onData { addToFavoritesResult in
                completion(.data(addToFavoritesResult.success))
            }
            result.onError { networkRequestError in
                completion(.error(networkRequestError))
            }
        }
    }
    
    func removeFromFavorites(userId: String, completion: @escaping ApiResult<Bool>.Completion) {
        let request = RemoveUserFromFavoritesRequest(userId: userId)
        networkClient.send(request: request) { result in
            result.onData { removeFromFavoritesResult in
                completion(.data(removeFromFavoritesResult.success))
            }
            result.onError { networkRequestError in
                completion(.error(networkRequestError))
            }
        }
    }
    
    func favoritesList(completion: @escaping ApiResult<SearchUserResult>.Completion) {
        currentFavoritesListTask?.cancel()
        
        let request = FavoriteUsersRequest()
        currentFavoritesListTask = networkClient.send(request: request, completion: completion)
    }
}
