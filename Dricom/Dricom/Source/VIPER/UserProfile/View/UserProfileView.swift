import UIKit

final class UserProfileView: UIView, ActivityDisplayable, StandardPreloaderViewHolder {
    let preloader = StandardPreloaderView(style: .dark)
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(preloader)
        
        backgroundColor = UIColor.drcWhite
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        preloader.frame = bounds
    }
}
