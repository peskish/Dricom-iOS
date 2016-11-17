import UIKit

final class RegisterView: ContentScrollingView {
    // MARK: - Properties
    private let backgroundView = RadialGradientView()
    private let addPhotoButton = ImageButtonView(image: UIImage(named: "Add photo"))
    private let addPhotoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = SpecColors.textMain
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        backgroundColor = SpecColors.Background.defaultEdge
        
        addSubview(backgroundView)
        addSubview(addPhotoButton)
        addSubview(addPhotoLabel)
        
        addPhotoButton.sizeToFit()
        addPhotoButton.layer.cornerRadius = addPhotoButton.width/2
        addPhotoButton.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = bounds
        
        addPhotoButton.size = addPhotoButton.sizeThatFits(bounds.size)
        addPhotoButton.top = SpecSizes.statusBarHeight * 3
        addPhotoButton.centerX = bounds.centerX
        
        addPhotoLabel.sizeToFit()
        addPhotoLabel.top = addPhotoButton.bottom + SpecMargins.innerContentMargin
        addPhotoLabel.centerX = bounds.centerX
        
        contentSize = CGSize(
            width: bounds.width,
            height: (subviews.last?.bottom ?? 0) + SpecMargins.contentMargin
        )
    }
    
    // MARK: Public
    func setAddPhotoTitle(_ title: String) {
        addPhotoLabel.text = title
    }
    
    func setAddPhotoImage(_ image: UIImage?) {
        addPhotoButton.setImage(image ?? UIImage(named: "Add photo"))
    }
    
    var onAddPhotoButtonTap: (() -> ())? {
        get { return addPhotoButton.onTap }
        set { addPhotoButton.onTap = newValue }
    }
}
