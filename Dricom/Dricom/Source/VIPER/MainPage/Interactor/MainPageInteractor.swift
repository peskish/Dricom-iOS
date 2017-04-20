import Foundation

typealias FavoritesLoadingCompletion = (DataLoadingResult<[User]>) -> ()

protocol MainPageInteractor: class {
    func searchUser(license: String, completion: @escaping ApiResult<UserInfo?>.Completion)
    func favoriteUsersList(completion: @escaping FavoritesLoadingCompletion)
    var onAccountDataReceived: ((User) -> ())? { get set }
}
