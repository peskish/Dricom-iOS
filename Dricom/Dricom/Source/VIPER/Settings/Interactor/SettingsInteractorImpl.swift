import Foundation

final class SettingsInteractorImpl: SettingsInteractor {
    // MARK: - Dependencies
    private let logoutService: LogoutService
    private let userDataObservable: UserDataObservable
    
    // MARK: - Init
    init(logoutService: LogoutService, userDataObservable: UserDataObservable) {
        self.logoutService = logoutService
        self.userDataObservable = userDataObservable
        
        self.userDataObservable.subscribe(self) { [weak self] user in
            self?.onUserDataReceived?(user)
        }
    }
    
    // MARK: - SettingsInteractor
    func logOut(completion: (() -> ())?) {
        logoutService.processLogoutAction(completion: completion)
    }
    
    var onUserDataReceived: ((User) -> ())?
}
