import Foundation

typealias FavoritesLoadingCompletion = (DataLoadingResult<[User]>) -> ()

protocol MainPageInteractor: class {
    func searchUsers(license: String, completion: @escaping ApiResult<[UserInfo]>.Completion)
    func favoriteUsersList(forceReload: Bool, completion: @escaping FavoritesLoadingCompletion)
    var onAccountDataReceived: ((User) -> ())? { get set }
}
