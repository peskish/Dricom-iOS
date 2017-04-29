import UIKit
import AlamofireImage

final class MainPageView: UIScrollView, StandardPreloaderViewHolder, ActivityDisplayable {
    // MARK: Properties
    private let accountView = MainPageAccountView()
    
    let preloader = StandardPreloaderView(style: .dark)
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        bounces = false
        
        addSubview(accountView)
        
        
        addSubview(preloader)
        
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Style
    private func setStyle() {
        backgroundColor = UIColor.drcWhite
        
        
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        accountView.size = accountView.sizeThatFits(bounds.size)
        accountView.top = bounds.top
        accountView.left = bounds.left
        
        preloader.frame = bounds
    }
    
    // MARK: Public
    func setSearchPlaceholder(_ placeholder: String) {
        // TODO:
    }
    
    func setAccountViewData(_ accountViewData: AccountViewData) {
        accountView.setViewData(accountViewData)
        setNeedsLayout()
    }
    
    var onSearchTextChange: ((String?) -> ())? // TODO:
    
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
