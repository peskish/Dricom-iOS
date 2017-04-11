import UIKit
import FastttCamera

final class CameraViewController: BaseViewController, CameraViewInput, FastttCameraDelegate {
    // MARK: - Properties
    private let cameraView = CameraView()
    private var previewViewController: CameraPreviewViewController? = nil
    private let fastCamera = FastttCamera()
    
    // MARK: - View events
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ФОТО" // TODO: to presenter
        
        setupViewHierarchy()
        
        setupNavigationBar()
        
        setupStyle()
        
        setupCamera()
        
        setupCallbacks()
    }
    
    private func setupStyle() {
        view.backgroundColor = UIColor.drcWhite
        fastCamera.view.backgroundColor = .black
        
        // Navigation bar
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.drcBlue
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.drcSlate,
            NSFontAttributeName: UIFont.drcScreenNameFont() ?? UIFont.systemFont(ofSize: 17)
        ]
        
        if let backgroundImage = UIImage.imageWithColor(UIColor.drcWhite) {
            navigationController?.navigationBar.setBackgroundImage(
                backgroundImage,
                for: .default
            )
        }
    }
    
    private func setupViewHierarchy() {
        fastttAddChildViewController(fastCamera)
        view.addSubview(cameraView)
        cameraView.cameraView = fastCamera.view
    }
    
    private func setupCallbacks() {
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
    
    private func setupCamera() {
        fastCamera.delegate = self
        fastCamera.maxScaledDimension = 600
        fastCamera.cameraFlashMode = .off
        cameraView.flashMode = .off
    }
    
    private func setupNavigationBar() {
        navigationItem.backBarButtonItem = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        cameraView.frame = view.bounds
        previewViewController?.view.frame = view.bounds
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
        previewViewController.onRetakePhotoButtonTap = { [weak self] in
            self?.hidePreview()
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
        let cameraFlashMode: CameraFlashMode
        switch fastCamera.cameraFlashMode {
        case .on:
            flashMode = .off
            cameraFlashMode = .off
        case .off, .auto:
            flashMode = .on
            cameraFlashMode = .on
        }
        if fastCamera.isFlashAvailableForCurrentDevice() {
            fastCamera.cameraFlashMode = flashMode
            cameraView.flashMode = cameraFlashMode
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
                cameraView.flashMode = .off
            }
        }
    }
}
