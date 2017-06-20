import Foundation

final class MainPageInteractorImpl: MainPageInteractor {
    // MARK: - Dependencies
    private let userDataObservable: UserDataObservable
    private let userSearchService: UserSearchService
    private let favoriteUsersService: FavoriteUsersService
    
    // MARK: - State
    private var favoriteUsersState = DataLoadingState<[User]>()
    private var favoriteUsersCallbacks = [FavoritesLoadingCompletion]()
    
    // MARK: - Init
    init(
        userDataObservable: UserDataObservable,
        userSearchService: UserSearchService,
        favoriteUsersService: FavoriteUsersService)
    {
        self.userDataObservable = userDataObservable
        self.userSearchService = userSearchService
        self.favoriteUsersService = favoriteUsersService
        
        self.userDataObservable.subscribe(self) { [weak self] user in
            self?.onAccountDataReceived?(user)
        }
    }
    
    // MARK: - MainPageInteractor
    func searchUsers(license: String, completion: @escaping ApiResult<[UserInfo]>.Completion) {
        userSearchService.searchUsers(license: license, shouldCancelPrevious: true) { result in
            result.onData { [weak self] userList in
                guard let `self` = self else { return }
                
                if let favoritesList = self.favoriteUsersState.previousLoadedData() {
                    completion(
                        .data(self.makeUserInfoList(userList: userList, favoritesList: favoritesList))
                    )
                } else {
                    self.favoriteUsersList(forceReload: false) { favoriteUsersResult in
                        completion(
                            .data(
                                self.makeUserInfoList(
                                    userList: userList,
                                    favoritesList: favoriteUsersResult.cachedData() ?? []
                                )
                            )
                        )
                    }
                }
            }
            result.onError { error in
                completion(.error(error))
            }
        }
    }
    
    func favoriteUsersList(forceReload: Bool, completion: @escaping FavoritesLoadingCompletion) {
        favoriteUsersCallbacks.append(completion)
        
        if forceReload {
            loadFavoriteUsersList()
            return
        }
        
        switch favoriteUsersState {
        case .pending, .completed:
            loadFavoriteUsersList()
        case .loading:
            return
        }
    }
    
    private func loadFavoriteUsersList() {
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
    
    private func callAndClearFavoriteUsersCallbacks(result: DataLoadingResult<[User]>) {
        favoriteUsersCallbacks.forEach{ $0(result) }
        favoriteUsersCallbacks.removeAll()
    }
    
    var onAccountDataReceived: ((User) -> ())?
    
    // MARK: - Private
    private func makeUserInfoList(userList: [User], favoritesList: [User]) -> [UserInfo] {
        return userList.map { UserInfo(user: $0, isInFavorites: favoritesList.contains($0)) }
    }
}
