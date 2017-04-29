import UIKit
import AlamofireImage

final class MainPageView: UIScrollView, StandardPreloaderViewHolder, ActivityDisplayable {
    // MARK: Properties
    private static let searchBarFont: UIFont = {
        if let font = UIFont.drcAccountLicenseFont() {
            return font
        } else {
            return UIFont.systemFont(ofSize: 15)
        }
    }()
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
    
    let preloader = StandardPreloaderView(style: .dark)
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        bounces = false
        
        addSubview(accountView)
        addSubview(searchBarView)
        
        addSubview(preloader)
        
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
        
        searchBarView.layout(left: bounds.left, top: bounds.top, width: bounds.width, height: 58)
        
        accountView.size = accountView.sizeThatFits(bounds.size)
        accountView.top = searchBarView.bottom
        accountView.left = bounds.left
        
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
        // TODO:
    }
    
    func setNoFavoritesTitle(_ title: String) {
        // TODO:
    }
    
    func setNoFavoritesDescription(_ decription: String) {
        // TODO:
    }
    
    func setFavorites(_ users: [UserViewData]) {
        // TODO:
    }
    
    func setUserSuggestList(_ suggestList: [UserViewData]) {
        // TODO:
    }
    
    var onUserSuggestTap: ((_ userId: String) -> ())?
}
