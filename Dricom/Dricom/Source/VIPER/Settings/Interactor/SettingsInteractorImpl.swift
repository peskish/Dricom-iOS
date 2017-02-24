import Foundation

final class SettingsInteractorImpl: SettingsInteractor {
    // MARK: - State
    private var user: User?
    
    // MARK: - SettingsInteractor
    func setUser(_ user: User) {
        self.user = user
    }
}
