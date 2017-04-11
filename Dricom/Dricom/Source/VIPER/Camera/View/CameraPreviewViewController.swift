import UIKit

final class CameraPreviewViewController: UIViewController {
    // MARK: - Properties
    private let previewView = CameraPreviewView()
    
    // MARK: - View events
    override func loadView() {
        view = previewView
    }
    
    // MARK: Layout
    var cameraArea: CGRect {
        get { return previewView.cameraArea }
        set { previewView.cameraArea = newValue }
    }
    
    // MARK: - Public
    func setPreviewImage(_ image: UIImage) {
        previewView.setPreviewImage(image)
    }
    
    func setUsePhotoButtonEnabled(_ enabled: Bool) {
        previewView.setUsePhotoButtonEnabled(enabled)
    }
    
    var onUsePhotoButtonTap: (() -> ())? {
        get { return previewView.onUsePhotoButtonTap }
        set { previewView.onUsePhotoButtonTap = newValue }
    }
    
    var onRetakePhotoButtonTap: (() -> ())? {
        get { return previewView.onRetakePhotoButtonTap }
        set { previewView.onRetakePhotoButtonTap = newValue }
    }
}
