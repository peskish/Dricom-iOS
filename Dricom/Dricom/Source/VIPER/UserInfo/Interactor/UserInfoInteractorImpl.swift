import Foundation

final class UserInfoInteractorImpl: UserInfoInteractor {
    // MARK: - State
    private var userInfo: UserInfo
    
    // MARK: - Dependencies
    private let favoriteUsersService: FavoriteUsersService
    private let phoneService: PhoneService
    
    // MARK: - Init
    init(userInfo: UserInfo, favoriteUsersService: FavoriteUsersService, phoneService: PhoneService) {
        self.userInfo = userInfo
        self.favoriteUsersService = favoriteUsersService
        self.phoneService = phoneService
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
    
    func callUser() {
        guard let phone = userInfo.user.phone else { return }
        phoneService.call(number: phone)
    }
}
