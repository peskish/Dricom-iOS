import UIKit

struct ImageButtonSet {
    let normal: UIImage?
    let highlighted: UIImage?
    let disabled: UIImage?
}

class ImageButtonView: UIView {
    // MARK: Properties
    private let button = UIButton(type: .custom)
    
    // MARK: Init
    init(imageSet: ImageButtonSet) {
        super.init(frame: .zero)
        
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        addSubview(button)
        
        setImageSet(imageSet)
        setStyle()
    }
    
    convenience init(image: UIImage?) {
        self.init(
            imageSet: ImageButtonSet(
                normal: image,
                highlighted: nil,
                disabled: nil
            )
        )
    }
    
    private func setImageSet(_ imageSet: ImageButtonSet) {
        button.setImage(imageSet.normal, for: .normal)
        button.setImage(imageSet.highlighted, for: .highlighted)
        button.setImage(imageSet.disabled, for: .disabled)
        
        if imageSet.highlighted == nil {
            button.adjustsImageWhenHighlighted = true
        }
    }
    
    private func setStyle() {
        backgroundColor = .clear
        
        button.backgroundColor = .clear
        button.contentMode = .center
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
