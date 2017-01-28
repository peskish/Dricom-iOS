import UIKit

enum ActionButtonStyle {
    case light
    case dark
    
    var colorScheme: ActionButtonColorScheme.Type {
        switch self {
        case .light:
            return SpecColors.ActionButton.Light.self
        case .dark:
            return SpecColors.ActionButton.Dark.self
        }
    }
}

class ActionButtonView: UIView {
    // MARK: Properties
    private let button = UIButton(type: .custom)
    
    // MARK: Init
    init() {
        super.init(frame: .zero)
        
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        addSubview(button)
        
        backgroundColor = .clear
        
        button.layer.cornerRadius = SpecSizes.actionButtonHeight/2
        button.layer.masksToBounds = true
        
        setColorScheme(style.colorScheme)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.layout(
            left: SpecMargins.contentSidePadding,
            right: bounds.width - SpecMargins.contentSidePadding,
            top: bounds.top,
            height: SpecSizes.actionButtonHeight
        )
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: SpecSizes.actionButtonHeight)
    }
    
    // MARK: - Actions
    @objc private func onButtonTap() {
        onTap?()
    }
    
    // MARK: - Public
    var style: ActionButtonStyle = .light {
        didSet {
            setColorScheme(style.colorScheme)
        }
    }
    
    var onTap: (() -> ())?
    
    func setTitle(_ title: String?) {
        button.setTitle(title, for: .normal)
    }
    
    // - MARK: Private
    private func setColorScheme(_ scheme: ActionButtonColorScheme.Type) {
        button.setTitleColor(scheme.title, for: .normal)
        button.setTitleColor(scheme.title, for: .highlighted)
        button.setBackgroundImage(
            UIImage.imageWithColor(scheme.normalBackground),
            for: .normal
        )
        button.setBackgroundImage(
            UIImage.imageWithColor(scheme.highlightedBackground),
            for: .highlighted
        )
        if let borderColor = scheme.border {
            button.layer.borderColor = borderColor.cgColor
            button.layer.borderWidth = 1
        } else {
            button.layer.borderColor = nil
            button.layer.borderWidth = 0
        }
    }
}
