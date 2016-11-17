import Foundation

final class CameraPresenter:
    CameraModule
{
    // MARK: - Private properties
    private let interactor: CameraInteractor
    private let router: CameraRouter
    
    // MARK: - Init
    init(interactor: CameraInteractor,
         router: CameraRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: CameraViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        view?.onCloseButtonTap = { [weak self] in
            self?.onFinish?(.cancelled)
        }
        
        view?.onDenyCameraPermission = { [weak self] in
            self?.onFinish?(.cancelled)
        }
        
        view?.onDidTakePhoto = { [weak self] image in
            self?.onFinish?(.finished(photo: image))
        }
    }
    
    // MARK: - CameraModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    var onFinish: ((CameraResult) -> ())?
}
