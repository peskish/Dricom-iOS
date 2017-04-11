import UIKit

enum CameraFlashMode {
    case on
    case off
}

final class CameraView: UIView {
    let takePhotoButton =  UIButton(type: .custom)
    let flashButton =  UIButton(type: .custom)
    let switchCameraButton =  UIButton(type: .custom)
    
    weak var cameraView: UIView?
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        takePhotoButton.setImage(#imageLiteral(resourceName: "Shutter"), for: .normal)
        takePhotoButton.addTarget(self, action: #selector(takePhotoTapped), for: .touchUpInside)
        addSubview(takePhotoButton)
        
        flashButton.addTarget(self, action: #selector(flashButtonTapped), for: .touchUpInside)
        addSubview(flashButton)
        
        switchCameraButton.setImage(#imageLiteral(resourceName: "SwitchCamera"), for: .normal)
        switchCameraButton.addTarget(self, action: #selector(switchCameraButtonTapped), for: .touchUpInside)
        addSubview(switchCameraButton)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    var cameraArea: CGRect {
        return cameraView?.frame ?? .zero
    }
    
    private let buttonsPadding: CGFloat = 25
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cameraView?.layout(
            left: bounds.left,
            right: bounds.right,
            top: bounds.top,
            height: bounds.width
        )
        
        takePhotoButton.sizeToFit()
        takePhotoButton.centerX = bounds.centerX
        takePhotoButton.bottom = bounds.bottom - 30
        
        flashButton.sizeToFit()
        flashButton.right = bounds.right - buttonsPadding
        flashButton.bottom = cameraArea.bottom - buttonsPadding
        
        switchCameraButton.sizeToFit()
        switchCameraButton.left = buttonsPadding
        switchCameraButton.bottom = cameraArea.bottom - buttonsPadding
    }
    
    // MARK: - Public
    var onTakePhotoTap: (() -> ())?
    
    var onFlashTap: (() -> ())?
    var flashMode: CameraFlashMode = .on {
        didSet {
            flashButton.setImage(flashMode == .on ? #imageLiteral(resourceName: "FlashOff") : #imageLiteral(resourceName: "FlashOn"), for: .normal)
        }
    }
    
    var onSwitchCameraTap: (() -> ())?
    
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
