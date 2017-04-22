import Foundation

final class UserInfoInteractorImpl: UserInfoInteractor {
    // MARK: - State
    private var userInfo: UserInfo
    
    // MARK: - Dependencies
    private let favoriteUsersService: FavoriteUsersService
    
    // MARK: - Init
    init(userInfo: UserInfo, favoriteUsersService: FavoriteUsersService) {
        self.userInfo = userInfo
        self.favoriteUsersService = favoriteUsersService
    }
    
    // MARK: - UserInfoInteractor
    func obtainUserInfo() -> UserInfo {
        return userInfo
    }
    
    func changeUserFavoritesStatus(completion: @escaping ApiResult<Void>.Completion) {
        if userInfo.isInFavorites {
            favoriteUsersService.removeFromFavorites(userId: userInfo.user.id) { result in
                result.onData { [weak self] success in
                    if success {
                        self?.userInfo.isInFavorites = false
                    }
                    completion(.data())
                }
                result.onError { error in
                    completion(.error(error))
                }
            }
        } else {
            favoriteUsersService.addToFavorites(userId: userInfo.user.id) { result in
                result.onData { [weak self] success in
                    if success {
                        self?.userInfo.isInFavorites = true
                    }
                    completion(.data())
                }
                result.onError { error in
                    completion(.error(error))
                }
            }
        }
    }
}
