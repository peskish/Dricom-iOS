import Foundation

final class MainPageInteractorImpl: MainPageInteractor {
    // MARK: - Dependencies
    private let userDataService: UserDataService
    
    // MARK: - Init
    init(userDataService: UserDataService) {
        self.userDataService = userDataService
        
        self.userDataService.subscribe(self) { [weak self] user in
            self?.onUserDataReceived?(user)
        }
    }
    
    // MARK: - MainPageInteractor
    var onUserDataReceived: ((User) -> ())?
}
