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
    func setAccountViewData(_ accountViewData: AccountViewData)
    func setFavoritesSectionTitle(_ title: String)
    func setNoFavoritesTitle(_ title: String)
    func setNoFavoritesDescription(_ text: String)
    func setFavorites(_ users: [UserRowViewData])
    func setSearchSuggestionsHidden(_ : Bool)
    func setUserSuggestList(_ suggestList: [UserRowViewData])
    var onSearchDidBegin: ((_ searchQuery: String) -> ())? { get set }
    var onSearchTextChange: ((String) -> ())? { get set }
    var onSearchCancelButtonTap: (() -> ())? { get set }
    var onSearchButtonTap: ((_ searchQuery: String) -> ())? { get set }
}
