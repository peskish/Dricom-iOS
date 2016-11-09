import UIKit

final class FeedbackView: UIView {
    private let logoImageView = UIImageView(image: UIImage(named: "Logo"))
    private let backgroundView = RadialGradientView()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(backgroundView)
        addSubview(logoImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = bounds
        
        // Logo image has strange size (too big) - i'll try to use the half of it for now
        guard let imageSize = logoImageView.image?.size else { return }
        
        logoImageView.size = CGSize(width: imageSize.width/2, height: imageSize.height/2)
        logoImageView.top = SpecSizes.statusBarHeight * 2
        logoImageView.centerX = bounds.centerX
    }
}
