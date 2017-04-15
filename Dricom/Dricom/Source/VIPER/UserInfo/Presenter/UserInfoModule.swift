import Foundation

protocol UserInfoModule: class {
    var onAddUserToFavorites: ((User) -> ())? { get set }
    var onRemoveUserFromFavorites: ((User) -> ())? { get set }
}
