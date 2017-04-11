import UIKit

class CameraPreviewView: UIView {
    // MARK: - Properties
    private let previewView = UIImageView()
    private let usePhotoButtonView = ActionButtonView()
    private let retakePhotoButtonView = ActionButtonView()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        
        previewView.contentMode = .scaleAspectFit
        addSubview(previewView)
        
        usePhotoButtonView.setTitle("Отлично!")
        usePhotoButtonView.style = .dark
        addSubview(usePhotoButtonView)
        
        retakePhotoButtonView.setTitle("Переснять")
        retakePhotoButtonView.style = .light
        addSubview(retakePhotoButtonView)
        
        backgroundColor = UIColor.drcWhite
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    var cameraArea: CGRect = .zero
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        previewView.layout(
            left: bounds.left,
            right: bounds.right,
            top: bounds.top,
            height: bounds.width
        )
        
        retakePhotoButtonView.layout(
            left: bounds.left,
            right: bounds.right,
            bottom: bounds.bottom - SpecMargins.contentSidePadding,
            height: SpecSizes.actionButtonHeight
        )
        
        usePhotoButtonView.layout(
            left: bounds.left,
            right: bounds.right,
            bottom: retakePhotoButtonView.top - SpecMargins.contentMargin,
            height: SpecSizes.actionButtonHeight
        )
    }
    
    // MARK: - Public
    func setPreviewImage(_ image: UIImage) {
        previewView.image = image
    }
    
    func setUsePhotoButtonEnabled(_ enabled: Bool) {
        usePhotoButtonView.setEnabled(enabled)
    }
    
    var onUsePhotoButtonTap: (() -> ())? {
        get { return usePhotoButtonView.onTap }
        set { usePhotoButtonView.onTap = newValue }
    }
    
    var onRetakePhotoButtonTap: (() -> ())? {
        get { return retakePhotoButtonView.onTap }
        set { retakePhotoButtonView.onTap = newValue }
    }
}
