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
    
    var onSearchDidBegin: ((_ searchQuery: String) -> ())? {
        get { return mainPageView.onSearchDidBegin }
        set { mainPageView.onSearchDidBegin = newValue }
    }
    
    var onSearchCancelButtonTap: (() -> ())? {
        get { return mainPageView.onSearchCancelButtonTap }
        set { mainPageView.onSearchCancelButtonTap = newValue }
    }
    
    var onSearchButtonTap: ((_ searchQuery: String) -> ())? {
        get { return mainPageView.onSearchButtonTap }
        set { mainPageView.onSearchButtonTap = newValue }
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
    
    func setNoFavoritesDescription(_ text: String) {
        mainPageView.setNoFavoritesDescription(text)
    }
    
    func setFavorites(_ users: [UserRowViewData]) {
        mainPageView.setFavorites(users)
    }
    
    func setSearchSuggestionsHidden(_ searchSuggestionsHidden: Bool) {
        mainPageView.setSearchSuggestionsHidden(searchSuggestionsHidden) { [weak self] didSet in
            if didSet {
                self?.navigationController?.setNavigationBarHidden(!searchSuggestionsHidden, animated: true)
            }
        }
    }
    
    func setUserSuggestList(_ suggestList: [UserRowViewData]) {
        mainPageView.setUserSuggestList(suggestList)
    }
    
    // MARK: ActivityDisplayable
    func startActivity() {
        mainPageView.startActivity()
    }
    
    func stopActivity() {
        mainPageView.stopActivity()
    }
}
