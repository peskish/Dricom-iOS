import UIKit

final class RegisterView: ContentScrollingView {
    // MARK: - Properties
    private let backgroundView = RadialGradientView()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        backgroundColor = SpecColors.Background.defaultEdge
        
        addSubview(backgroundView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = bounds
        
//        contentSize = CGSize(width: bounds.width, height: max(bounds.height, infoButtonView.bottom))
    }
}
