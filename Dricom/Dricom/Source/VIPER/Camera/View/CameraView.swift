import UIKit

final class CameraView: UIView {
    let takePhotoButton =  UIButton(type: .custom)
    let flashButton =  UIButton(type: .custom)
    let switchCameraButton =  UIButton(type: .custom)
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        takePhotoButton.addTarget(self, action: #selector(takePhotoTapped), for: .touchUpInside)
        addSubview(takePhotoButton)
        
        flashButton.addTarget(self, action: #selector(flashButtonTapped), for: .touchUpInside)
        addSubview(flashButton)
        
        switchCameraButton.addTarget(self, action: #selector(switchCameraButtonTapped), for: .touchUpInside)
        addSubview(switchCameraButton)
        
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
        
        flashButton.sizeToFit()
        flashButton.left = SpecMargins.contentMargin
        flashButton.bottom = cameraArea.top - SpecMargins.contentMargin
        
        switchCameraButton.sizeToFit()
        switchCameraButton.right = bounds.right - SpecMargins.contentMargin
        switchCameraButton.bottom = cameraArea.top - SpecMargins.contentMargin
        
        activityIndicator.center = cameraArea.center
    }
    
    // MARK: - Public
    var onTakePhotoTap: (() -> ())?
    func setTakePhotoButtonTitle(_ title: String) {
        takePhotoButton.setTitle(title, for: .normal)
    }
    
    var onFlashTap: (() -> ())?
    func setFlashButtonTitle(_ title: String) {
        flashButton.setTitle(title, for: .normal)
    }
    
    var onSwitchCameraTap: (() -> ())?
    func setSwitchCameraButtonTitle(_ title: String) {
        switchCameraButton.setTitle(title, for: .normal)
    }
    
    // MARK: - Private
    @objc private func takePhotoTapped() {
        onTakePhotoTap?()
    }
    
    @objc private func flashButtonTapped() {
        onFlashTap?()
    }
    
    @objc private func switchCameraButtonTapped() {
        onSwitchCameraTap?()
    }
}
