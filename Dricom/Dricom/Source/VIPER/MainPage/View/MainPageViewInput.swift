import Foundation

struct AccountViewData {
    let avatarImageUrl: URL?
    let name: String?
    let license: String?
}

struct UserRowViewData {
    let id: String
    let avatarImageUrl: URL?
    let name: String?
    let license: String?
    let isInFavorites: Bool
    
    let onTap: (() -> ())?
}

protocol MainPageViewInput: class, ViewLifecycleObservable, MessageDisplayable, ActivityDisplayable {
    func setScreenTitle(_ title: String)
    func setSearchPlaceholder(_ placeholder: String)
    var onSearchTextChange: ((String) -> ())? { get set }
    func setAccountViewData(_ accountViewData: AccountViewData)
    func setFavoritesSectionTitle(_ title: String)
    func setNoFavoritesTitle(_ title: String)
    func setNoFavoritesDescription(_ decription: String)
    func setFavorites(_ users: [UserRowViewData])
    func setUserSuggestList(_ suggestList: [UserRowViewData])
}
