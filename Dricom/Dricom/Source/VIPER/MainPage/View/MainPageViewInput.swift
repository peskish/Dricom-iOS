import Foundation

struct UserViewData {
    let id: String
    let avatarUrl: String?
    let name: String?
    let license: String?
    let isInFavorites: Bool
}

protocol MainPageViewInput: class, ViewLifecycleObservable, MessageDisplayable, ActivityDisplayable {
    func setScreenTitle(_ title: String)
    func setSearchPlaceholder(_ placeholder: String)
    var onSearchTextChange: ((String?) -> ())? { get set }
    func setName(_ name: String?)
    func setAvatarImageUrl(_ avatarImageUrl: URL?)
    func setLicenseParts(_ licenseParts: LicenseParts)
    func setFavoritesSectionTitle(_ title: String)
    func setNoFavoritesTitle(_ title: String)
    func setNoFavoritesDescription(_ decription: String)
    func setFavorites(_ users: [UserViewData])
    func setUserSuggestList(_ suggestList: [UserViewData])
    var onUserSuggestTap: ((_ userId: String) -> ())? { get set }
}
