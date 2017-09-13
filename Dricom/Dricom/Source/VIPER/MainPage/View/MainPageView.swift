import UIKit
import AlamofireImage

final class MainPageView: UIScrollView, StandardPreloaderViewHolder, ActivityDisplayable {
    // MARK: Properties
    private static let searchBarFont = SpecFonts.ralewayRegular(14)
    private let accountView = MainPageAccountView()
    private let searchBarView = SearchBarView(
        textColor: .drcSlate,
        placeholderColor: .drcCoolGreyTwo,
        separatorColor: .drcPaleGreyTwo,
        searchFieldBackgroundColor: .drcPaleGreyThree,
        searchBarBackgroundColor: .drcWhite,
        font: MainPageView.searchBarFont,
        searchTextPositionAdjustment: UIOffset(horizontal: 5, vertical: 0)
    )
    private let favoritesSectionTitleView = MainPageSectionTitleView()
    private let favoritesListView = MainPageUsersTableView()
    private let noFavoriteUsersView = MainPageNoFavoriteUsersView()
    private let searchSuggestionsView = MainPageUsersTableView()
    
    let preloader = StandardPreloaderView(style: .dark)
    
    private var isSearchSuggestionsViewHidden: Bool {
        return searchSuggestionsView.isHidden == true
    }
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        bounces = false
        
        addSubview(accountView)
        addSubview(searchBarView)
        addSubview(favoritesSectionTitleView)
        addSubview(favoritesListView)
        addSubview(noFavoriteUsersView)
        addSubview(searchSuggestionsView)
        
        addSubview(preloader)
        
        noFavoriteUsersView.isHidden = true
        favoritesListView.isHidden = true
        searchSuggestionsView.isHidden = true
        
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Style
    private func setStyle() {
        backgroundColor = UIColor.drcWhite
        
        searchBarView.setImage(#imageLiteral(resourceName: "Loupe gray"), forIcon: .magnifyingGlass, state: .normal)
        searchBarView.setImage(#imageLiteral(resourceName: "Clear"), forIcon: .clear, state: .normal)
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchBarView.layout(left: bounds.left, top: 0, width: bounds.width, height: 58)
        
        accountView.size = accountView.sizeThatFits(bounds.size)
        accountView.top = searchBarView.bottom
        accountView.left = bounds.left
        
        favoritesSectionTitleView.layout(
            left: bounds.left,
            top: accountView.bottom,
            width: bounds.width,
            height: favoritesSectionTitleView.sizeThatFits().height
        )
        
        favoritesListView.layout(
            left: bounds.left,
            right: bounds.right,
            top: favoritesSectionTitleView.bottom,
            bottom: bounds.bottom
        )
        
        noFavoriteUsersView.frame = favoritesListView.frame
        
        searchSuggestionsView.layout(
            left: bounds.left,
            right: bounds.right,
            top: searchBarView.bottom,
            bottom: bounds.bottom
        )
        
        preloader.frame = bounds
    }
    
    // MARK: Public
    func setSearchPlaceholder(_ placeholder: String) {
        searchBarView.placeholder = placeholder
    }
    
    func setAccountViewData(_ accountViewData: AccountViewData) {
        accountView.setViewData(accountViewData)
        setNeedsLayout()
    }
    
    var onSearchTextChange: ((String) -> ())? {
        get { return searchBarView.onTextChange }
        set { searchBarView.onTextChange = newValue }
    }
    
    func setFavoritesSectionTitle(_ title: String) {
        favoritesSectionTitleView.setTitle(title)
    }
    
    func setNoFavoritesTitle(_ title: String) {
        noFavoriteUsersView.setTitle(title)
    }
    
    func setNoFavoritesDescription(_ text: String) {
        noFavoriteUsersView.setDescription(text)
    }
    
    func setFavorites(_ users: [UserRowViewData]) {
        favoritesListView.setViewDataList(users)
        
        favoritesListView.isHidden = users.isEmpty
        noFavoriteUsersView.isHidden = !favoritesListView.isHidden
    }
    
    func setSearchSuggestionsHidden(_ searchSuggestionsHidden: Bool, completion: ((_ didSet: Bool) -> ())) {
        guard isSearchSuggestionsViewHidden != searchSuggestionsHidden
            else { completion(false); return }
        
        searchSuggestionsView.isHidden = searchSuggestionsHidden
        
        searchBarView.setShowsCancelButton(!searchSuggestionsHidden, animated: true)
        
        if searchSuggestionsHidden {
            searchBarView.endEditing(true)
        } else {
            searchBarView.becomeFirstResponder()
        }
        
        setNeedsLayout() // Force the view controller to update content insets
        
        completion(true)
    }
    
    var onSearchDidBegin: ((_ searchQuery: String) -> ())? {
        didSet {
            searchBarView.onTextDidBeginEditing = { [weak self] in
                self?.onSearchDidBegin?(self?.searchBarView.text ?? "")
            }
        }
    }
    
    var onSearchTextDidChange: ((_ searchQuery: String) -> ())? {
        get { return searchBarView.onTextChange }
        set { searchBarView.onTextChange = newValue }
    }
    
    var onSearchCancelButtonTap: (() -> ())? {
        get { return searchBarView.onCancelButtonTap }
        set { searchBarView.onCancelButtonTap = newValue }
    }
    
    var onSearchButtonTap: ((_ searchQuery: String) -> ())? {
        didSet {
            searchBarView.onSearchButtonTap = { [weak self] in
                self?.onSearchButtonTap?(self?.searchBarView.text ?? "")
            }
        }
    }
    
    func setUserSuggestList(_ suggestList: [UserRowViewData]) {
        searchSuggestionsView.setViewDataList(suggestList)
        if let searchText = searchBarView.text {
            searchSuggestionsView.showEmptyDataView(suggestList.isEmpty && searchText.isNotEmpty)
        }
    }
}
