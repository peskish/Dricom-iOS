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
            self?.onUserDataReceived?(user)
        }
    }
    
    // MARK: - MainPageInteractor
    func searchUser(license: String, completion: @escaping ApiResult<User?>.Completion) {
        userSearchService.searchUser(
            license: license,
            completion: completion
        )
    }
    
    var onUserDataReceived: ((User) -> ())?
}
