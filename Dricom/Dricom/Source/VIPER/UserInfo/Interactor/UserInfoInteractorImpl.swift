import Foundation

final class UserInfoInteractorImpl: UserInfoInteractor {
    private let userInfo: UserInfo
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
    
    // MARK: - UserInfoInteractor
    func obtainUserInfo() -> UserInfo {
        return userInfo
    }
}
