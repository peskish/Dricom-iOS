import UIKit

class MainPageSectionTitleView: UIView {
    // MARK: Properties
    private let titleLabel = UILabel()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        addSubview(titleLabel)
        
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Style
    private func setStyle() {
        backgroundColor = UIColor.drcPaleGreyThree
        
        titleLabel.font = SpecFonts.ralewayRegular(14)
        titleLabel.textColor = UIColor.drcCoolGreyTwo
    }
    
    // MARK: Layout
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 32)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.layout(
            left: SpecMargins.contentMargin,
            right: bounds.right - SpecMargins.contentMargin,
            top: bounds.top,
            bottom: bounds.bottom
        )
    }
    
    // MARK: - Content
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
