import UIKit
import FastttCamera

final class CameraViewController: BaseViewController, CameraViewInput, FastttCameraDelegate {
    // MARK: - Properties
    private let cameraView = CameraView()
    private var previewViewController: CameraPreviewViewController? = nil
    private let fastCamera = FastttCamera()
    
    // MARK: - View events
    override func loadView() {
        super.loadView()
        
        view = cameraView
    }
    
    override func viewDidLoad() {
        fastCamera.delegate = self
        fastCamera.maxScaledDimension = 600
        fastttAddChildViewController(fastCamera)
        
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Close"),
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
        
        cameraView.setTakePhotoButtonTitle("Take photo")
        cameraView.setSwitchCameraButtonTitle("Switch camera")
        
        fastCamera.cameraFlashMode = .off
        cameraView.setFlashButtonTitle("Flash off")
        
        cameraView.onTakePhotoTap = { [fastCamera] in
            fastCamera.takePicture()
        }
        
        cameraView.onFlashTap = { [weak self] in
            self?.onFlashButtonTap()
        }
        
        cameraView.onSwitchCameraTap = { [weak self] in
            self?.onSwitchCameraTap()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let side = min(view.width, view.height)
        fastCamera.view.size = CGSize(width: side, height: side)
        fastCamera.view.center = view.center
        
        previewViewController?.view.frame = view.frame
        
        cameraView.cameraArea = CGRect(
            x: view.centerX - side/2,
            y: view.centerY - side/2,
            width: side,
            height: side
        )
    }
    
    // MARK: - CameraViewInput
    var onCloseButtonTap: (() -> ())?
    @objc private func closeButtonTapped() {
        if previewViewController != nil {
            hidePreview()
        } else {
            onCloseButtonTap?()
        }
    }
    
    var onDidTakePhoto: ((UIImage) -> ())?
    var onDenyCameraPermission: (() -> ())?
    
    // MARK: - FastttCameraDelegate
    func cameraController(
        _ cameraController: FastttCameraInterface!,
        didFinishCapturing capturedImage: FastttCapturedImage! )
    {
        showPreview(capturedImage: capturedImage)
    }
    
    func cameraController(
        _ cameraController: FastttCameraInterface!,
        didFinishNormalizing capturedImage: FastttCapturedImage!)
    {
        previewViewController?.setUsePhotoButtonEnabled(true)
    }
    
    func userDeniedCameraPermissions(forCameraController cameraController: FastttCameraInterface!) {
        onDenyCameraPermission?()
    }
    
    // MARK: - Private
    private func showPreview(capturedImage: FastttCapturedImage) {
        guard self.previewViewController == nil else {
            assertionFailure("Attempt to present second preview view controller")
            return
        }
        
        let previewViewController = CameraPreviewViewController()
        previewViewController.setPreviewImage(capturedImage.rotatedPreviewImage)
        previewViewController.setUsePhotoButtonEnabled(capturedImage.isNormalized)
        previewViewController.cameraArea = cameraView.cameraArea
        previewViewController.onUsePhotoButtonTap = { [weak self] in
            self?.onDidTakePhoto?(capturedImage.fullImage)
        }
        
        self.previewViewController = previewViewController
        
        animateShowing(previewViewController: previewViewController)
    }
    
    private func hidePreview() {
        fastttRemoveChildViewController(previewViewController)
        previewViewController = nil
    }
    
    private func animateShowing(previewViewController: CameraPreviewViewController) {
        let flashView = makeFlashView(frame: cameraView.cameraArea)
        view.addSubview(flashView)
        
        UIView.animate(
            withDuration: 0.1,
            delay: 0.05,
            options: .curveEaseIn,
            animations: {
                flashView.alpha = 1
            },
            completion: { [weak self] _ in
                self?.fastttAddChildViewController(previewViewController, belowSubview:flashView)
                
                UIView.animate(
                    withDuration: 0.1,
                    delay: 0.05,
                    options: .curveEaseOut,
                    animations: {
                        flashView.alpha = 0
                    },
                    completion: { _ in
                        flashView.removeFromSuperview()
                    }
                )
            }
        )
    }
    
    private func makeFlashView(frame: CGRect) -> UIView {
        let flashView = UIView()
        flashView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        flashView.alpha = 0
        flashView.frame = frame
        return flashView
    }
    
    private func onFlashButtonTap() {
        let flashMode: FastttCameraFlashMode
        let flashButtonTitle: String
        switch fastCamera.cameraFlashMode {
        case .on:
            flashMode = .off
            flashButtonTitle = "Flash off"
        case .off, .auto:
            flashMode = .on
            flashButtonTitle = "Flash on"
        }
        if fastCamera.isFlashAvailableForCurrentDevice() {
            fastCamera.cameraFlashMode = flashMode
            cameraView.setFlashButtonTitle(flashButtonTitle)
        }
    }
    
    private func onSwitchCameraTap() {
        let cameraDevice: FastttCameraDevice
        switch fastCamera.cameraDevice {
        case .front:
            cameraDevice = .rear
        case .rear:
            cameraDevice = .front
        }
        if FastttCamera.isCameraDeviceAvailable(cameraDevice) {
            fastCamera.cameraDevice = cameraDevice
            if fastCamera.isFlashAvailableForCurrentDevice() {
                let flashButtonTitle = "Flash off"
                cameraView.setFlashButtonTitle(flashButtonTitle)
            }
        }
    }
}
