import Foundation

final class MainPageInteractorImpl: MainPageInteractor {
    // MARK: - Dependencies
    private let userDataService: UserDataService
    private let userSearchService: UserSearchService
    private let favoriteUsersService: FavoriteUsersService
    
    // MARK: - State
    private var favoriteUsersState = DataLoadingState<[User]>()
    private var favoriteUsersCallbacks = [FavoritesLoadingCompletion]()
    
    // MARK: - Init
    init(
        userDataService: UserDataService,
        userSearchService: UserSearchService,
        favoriteUsersService: FavoriteUsersService)
    {
        self.userDataService = userDataService
        self.userSearchService = userSearchService
        self.favoriteUsersService = favoriteUsersService
        
        self.userDataService.subscribe(self) { [weak self] user in
            self?.onAccountDataReceived?(user)
        }
    }
    
    // MARK: - MainPageInteractor
    func searchUser(license: String, completion: @escaping ApiResult<UserInfo?>.Completion) {
        userSearchService.searchUser(license: license) { result in
            result.onData { [weak self] user in
                if let user = user {
                    if let favoritesList = self?.favoriteUsersState.previousLoadedData() {
                        completion(
                            .data(UserInfo(user: user, isInFavorites: favoritesList.contains(user)))
                        )
                    } else {
                        self?.favoriteUsersList { favoriteUsersResult in
                            let isInFavorites = favoriteUsersResult.cachedData()?.contains(user) ?? false
                            completion(
                                .data(UserInfo(user: user, isInFavorites: isInFavorites))
                            )
                        }
                    }
                } else {
                    completion(.data(nil))
                }
            }
            result.onError { error in
                completion(.error(error))
            }
        }
    }
    
    func favoriteUsersList(completion: @escaping FavoritesLoadingCompletion) {
        favoriteUsersCallbacks.append(completion)
        
        switch favoriteUsersState {
        case .pending,
             .completed:
            do {
                let previousResult = favoriteUsersState.previousLoadedData()
                favoriteUsersState = .loading
                favoriteUsersService.favoritesList { [weak self] result in
                    result.onData { searchUserResult in
                        let result: DataLoadingResult<[User]> = .loaded(
                            data: searchUserResult.results
                        )
                        self?.favoriteUsersState = .completed(result: result)
                        self?.callAndClearFavoriteUsersCallbacks(result: result)
                    }
                    result.onError { networkRequestError in
                        let result: DataLoadingResult<[User]> = .error(
                            error: networkRequestError,
                            previousResult: previousResult
                        )
                        self?.favoriteUsersState = .completed(result: result)
                        self?.callAndClearFavoriteUsersCallbacks(result: result)
                    }
                }
            }
        case .loading:
            return
        }
    }
    
    private func callAndClearFavoriteUsersCallbacks(result: DataLoadingResult<[User]>) {
        favoriteUsersCallbacks.forEach{ $0(result) }
        favoriteUsersCallbacks.removeAll()
    }
    
    var onAccountDataReceived: ((User) -> ())?
}
