import UIKit

class InfoButtonView: UIView {
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
        
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "Info sign"), for: .normal)
        button.contentMode = .center
        button.adjustsImageWhenHighlighted = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = bounds
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return SpecSizes.minimumButtonArea
    }
    
    // MARK: - Actions
    var onTap: (() -> ())?
    
    @objc private func onButtonTap() {
        onTap?()
    }
}
