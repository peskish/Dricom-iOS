import UIKit

final class MainPageViewController: BaseViewController, MainPageViewInput {
    // MARK: - Properties
    private let mainPageView = MainPageView()
    
    // MARK: - View events
    override func loadView() {
        view = mainPageView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setStyle(.main)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        mainPageView.contentInset = defaultContentInsets
    }
    
    // MARK: - MainPageViewInput
    func setScreenTitle(_ title: String) {
        self.title = title
    }
    
    func setSearchPlaceholder(_ placeholder: String) {
        mainPageView.setSearchPlaceholder(placeholder)
    }
    
    var onSearchTextChange: ((String) -> ())? {
        get { return mainPageView.onSearchTextChange }
        set { mainPageView.onSearchTextChange = newValue }
    }
    
    func setAccountViewData(_ accountViewData: AccountViewData) {
        mainPageView.setAccountViewData(accountViewData)
    }
    
    func setFavoritesSectionTitle(_ title: String) {
        mainPageView.setFavoritesSectionTitle(title)
    }
    
    func setNoFavoritesTitle(_ title: String) {
        mainPageView.setNoFavoritesTitle(title)
    }
    
    func setNoFavoritesDescription(_ decription: String) {
        mainPageView.setNoFavoritesDescription(decription)
    }
    
    func setFavorites(_ users: [UserViewData]) {
        mainPageView.setFavorites(users)
    }
    
    func setUserSuggestList(_ suggestList: [UserViewData]) {
        mainPageView.setUserSuggestList(suggestList)
    }
    
    var onUserSuggestTap: ((_ userId: String) -> ())? {
        get { return mainPageView.onUserSuggestTap }
        set { mainPageView.onUserSuggestTap = newValue }
    }
    
    // MARK: ActivityDisplayable
    func startActivity() {
        mainPageView.startActivity()
    }
    
    func stopActivity() {
        mainPageView.stopActivity()
    }
}
