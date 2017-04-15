import Foundation

final class UserInfoInteractorImpl: UserInfoInteractor {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    // MARK: - UserInfoInteractor
    func obtainUser() -> User {
        return user
    }
}
