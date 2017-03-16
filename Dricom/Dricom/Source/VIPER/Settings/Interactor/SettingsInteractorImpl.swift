import Foundation

final class SettingsInteractorImpl: SettingsInteractor {
    // MARK: - Dependencies
    private let logoutService: LogoutService
    private let userDataService: UserDataService
    
    // MARK: - Init
    init(logoutService: LogoutService, userDataService: UserDataService) {
        self.logoutService = logoutService
        self.userDataService = userDataService
        
        self.userDataService.subscribe(self) { [weak self] user in
            self?.onUserDataReceived?(user)
        }
    }
    
    // MARK: - SettingsInteractor
    func logOut(completion: (() -> ())?) {
        logoutService.processLogoutAction(completion: completion)
    }
    
    var onUserDataReceived: ((User) -> ())?
}
