import UIKit

final class CameraView: UIView {
    let takePhotoButton =  UIButton(type: .custom)
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        takePhotoButton.addTarget(self, action: #selector(takePhotoTapped), for: .touchUpInside)
        addSubview(takePhotoButton)
        
        takePhotoButton.backgroundColor = .clear
        takePhotoButton.setTitleColor(SpecColors.ActionButton.highlightedBackground, for: .highlighted)
        takePhotoButton.setTitle("Take photo", for: .normal)
        
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Style
    private func setStyle() {
        backgroundColor = SpecColors.Background.defaultEdge
    }
    
    // MARK: Layout
    var cameraArea: CGRect = .zero
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        takePhotoButton.sizeToFit()
        takePhotoButton.centerX = bounds.centerX
        takePhotoButton.top = cameraArea.bottom + SpecMargins.contentMargin
        
        activityIndicator.center = cameraArea.center
    }
    
    // MARK: - Public
    var onTakePhotoTap: (() -> ())?
    
    // MARK: - Private
    @objc private func takePhotoTapped() {
        onTakePhotoTap?()
    }
}
