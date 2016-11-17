import Foundation

final class RegisterPresenter:
    RegisterModule
{
    // MARK: - Private properties
    private let interactor: RegisterInteractor
    private let router: RegisterRouter
    
    // MARK: - Init
    init(interactor: RegisterInteractor,
         router: RegisterRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: RegisterViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        view?.setAddPhotoTitle("Добавьте фото")
        
        view?.onAddPhotoButtonTap = { [weak self] in
            let actionSheet = StandardAlert(type: .actionSheet)
            actionSheet.cancelButton = StandardAlert.Button("Отмена", type: .cancel)
            let takePhotoButton = StandardAlert.Button("Сделать фото", type: .custom) { [weak self] in
                self?.takeAvatarPhoto()
            }
            let selectPhotoButton = StandardAlert.Button("Выбрать из галереи", type: .custom) { [weak self] in
                self?.selectAvatarPhoto()
            }
            actionSheet.buttons = [takePhotoButton, selectPhotoButton]
            self?.view?.showAlert(actionSheet)
        }
    }
    
    private func takeAvatarPhoto() {
        router.showCamera { [weak self] cameraModule in
            let module = cameraModule
            cameraModule.onFinish = { [weak module] result in
                if case .finished(let avatar) = result {
                    self?.interactor.setAvatar(avatar)
                    self?.view?.setAddPhotoImage(avatar)
                }
                
                module?.dismissModule()
            }
        }
    }
    
    private func selectAvatarPhoto() {
        print("selectAvatarPhoto")
    }
    
    // MARK: - RegisterModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    var onFinish: ((RegisterResult) -> ())?
}
