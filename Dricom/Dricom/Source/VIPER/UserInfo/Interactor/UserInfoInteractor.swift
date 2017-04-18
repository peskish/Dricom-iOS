import Foundation

struct UserInfo {
    let user: User
    let isInFavorites: Bool
}

protocol UserInfoInteractor: class {
    func obtainUserInfo() -> UserInfo
}
