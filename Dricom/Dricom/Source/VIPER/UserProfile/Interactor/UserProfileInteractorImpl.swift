import Foundation

final class UserProfileInteractorImpl: UserProfileInteractor {
    // MARK: - Dependencies
    private let userDataService: UserDataService
    
    // MARK: - Init
    init(userDataService: UserDataService) {
        self.userDataService = userDataService
        
        self.userDataService.subscribe(self) { [weak self] user in
            self?.onUserDataReceived?(user)
        }
    }
    
    // MARK: - UserProfileInteractor
    func requestUserData(completion: ApiResult<Void>.Completion?) {
        userDataService.requestUserData(completion: completion)
    }
    
    var onUserDataReceived: ((User) -> ())?
}
