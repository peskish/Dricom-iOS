import UIKit

class ActionButtonView: UIView {
    // MARK: Properties
    private let button = UIButton(type: .custom)
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        addSubview(button)
        
        setStyle()
    }
    
    private func setStyle() {
        backgroundColor = .clear
        
        button.setTitleColor(SpecColors.ActionButton.title, for: .normal)
        button.setTitleColor(SpecColors.ActionButton.title, for: .highlighted)
        button.setBackgroundImage(
            UIImage.imageWithColor(SpecColors.ActionButton.normalBackground),
            for: .normal
        )
        button.setBackgroundImage(
            UIImage.imageWithColor(SpecColors.ActionButton.highlightedBackground),
            for: .highlighted
        )
        
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.layout(
            left: SpecMargins.contentMargin,
            right: bounds.width - SpecMargins.contentMargin,
            top: bounds.top,
            height: SpecMargins.actionButtonHeight
        )
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: SpecMargins.actionButtonHeight)
    }
    
    // MARK: - Actions
    @objc private func onButtonTap() {
        onTap?()
    }
    
    // MARK: - Public
    var onTap: (() -> ())?
    func setTitle(_ title: String?) {
        button.setTitle(title, for: .normal)
    }
}
