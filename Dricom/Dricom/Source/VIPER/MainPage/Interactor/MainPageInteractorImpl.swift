import Foundation

final class MainPageInteractorImpl: MainPageInteractor {
    // MARK: - Dependencies
    private let userDataService: UserDataService
    private let userSearchService: UserSearchService
    
    // MARK: - Init
    init(userDataService: UserDataService, userSearchService: UserSearchService) {
        self.userDataService = userDataService
        self.userSearchService = userSearchService
        
        self.userDataService.subscribe(self) { [weak self] user in
            self?.onAccountDataReceived?(user)
        }
    }
    
    // MARK: - MainPageInteractor
    func searchUser(license: String, completion: @escaping ApiResult<UserInfo?>.Completion) {
        userSearchService.searchUser(license: license) { result in
            result.onData { user in
                // TODO: get favorites and return data
            }
            result.onError { error in
                completion(.error(error))
            }
        }
    }
    
    var onAccountDataReceived: ((User) -> ())?
}
