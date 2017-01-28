import UIKit

class CameraPreviewView: UIView {
    // MARK: - Properties
    private let previewView = UIImageView()
    private let usePhotoButton = UIButton(type: .custom)
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        previewView.contentMode = .scaleAspectFit
        addSubview(previewView)
        
        usePhotoButton.addTarget(self, action: #selector(usePhotoButtonTapped), for: .touchUpInside)
        addSubview(usePhotoButton)
        
        usePhotoButton.backgroundColor = .clear
        usePhotoButton.setTitle("Use photo", for: .normal)
        
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
        
        previewView.center = bounds.center
        previewView.size = cameraArea.size
        
        usePhotoButton.sizeToFit()
        usePhotoButton.centerX = bounds.centerX
        usePhotoButton.top = cameraArea.bottom + SpecMargins.contentMargin
    }
    
    // MARK: - Public
    func setPreviewImage(_ image: UIImage) {
        previewView.image = image
    }
    
    func setUsePhotoButtonEnabled(_ enabled: Bool) {
        usePhotoButton.isEnabled = enabled
    }
    
    var onUsePhotoButtonTap: (() -> ())?
    @objc private func usePhotoButtonTapped() {
        onUsePhotoButtonTap?()
    }
}
