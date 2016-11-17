import UIKit

struct ImageButtonSet {
    let normal: UIImage?
    let highlighted: UIImage?
    let disabled: UIImage?
}

class ImageButtonView: UIView {
    // MARK: Properties
    let button = UIButton(type: .custom)
    let customSize: CGSize?
    
    // MARK: Init
    init(imageSet: ImageButtonSet, customSize: CGSize? = nil) {
        self.customSize = customSize
        
        super.init(frame: .zero)
        
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        addSubview(button)
        
        setImageSet(imageSet)
        setStyle()
    }
    
    convenience init(image: UIImage?, customSize: CGSize? = nil) {
        self.init(
            imageSet: ImageButtonSet(
                normal: image,
                highlighted: nil,
                disabled: nil
            ),
            customSize: customSize
        )
    }
    
    func setImage(_ image: UIImage?) {
        setImageSet(
            ImageButtonSet(
                normal: image,
                highlighted: nil,
                disabled: nil
            )
        )
    }
    
    func setImageSet(_ imageSet: ImageButtonSet) {
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
        if let customSize = customSize {
            return customSize
        }
        
        let imageSize = button.image(for: .normal)?.size ?? .zero
        let width = max(imageSize.width, SpecSizes.minimumButtonArea.width)
        let height = max(imageSize.height, SpecSizes.minimumButtonArea.height)
        return CGSize(width: width, height: height)
    }
    
    // MARK: - Actions
    var onTap: (() -> ())?
    
    @objc private func onButtonTap() {
        onTap?()
    }
}
