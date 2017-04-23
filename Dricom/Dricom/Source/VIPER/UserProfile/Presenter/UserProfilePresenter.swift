import ImageSource

final class UserProfilePresenter:
    UserProfileModule
{
    // MARK: - Private properties
    private let interactor: UserProfileInteractor
    private let router: UserProfileRouter
    
    // MARK: - Init
    init(interactor: UserProfileInteractor,
         router: UserProfileRouter)
    {
        self.interactor = interactor
        self.router = router
        
        interactor.onUserDataReceived = { [weak self] user in
            self?.presentUser(user)
        }
    }
    
    // MARK: - Weak properties
    weak var view: UserProfileViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private enum ViewState {
        case read
        case edit
    }
    
    private func setUpView() {
        view?.setViewTitle("Профиль")
        view?.setAddPhotoTitle("Изменить фото")
        view?.setRightButtonEnabled(false)
        
        view?.setInputPlaceholder(field: .name, placeholder: "Ваше имя")
        view?.setInputPlaceholder(field: .email, placeholder: "Ваш Email")
        view?.setInputPlaceholder(field: .phone, placeholder: "Контактный телефон")
        
        view?.setOnInputChange(field: .name) { [weak self] text in
            self?.interactor.setName(text)
            self?.validateDataAndShowError(to: .name)
        }
        
        view?.setOnInputChange(field: .email) { [weak self] text in
            self?.interactor.setEmail(text)
            self?.validateDataAndShowError(to: .email)
        }
        
        view?.setOnInputChange(field: .phone) { [weak self] text in
            self?.interactor.setPhone(text)
            self?.validateDataAndShowError(to: .phone)
        }
        
        view?.onChangePhotoButtonTap = { [weak self] in
            self?.showAddPhotoActionSheet()
        }
        
        view?.onViewDidLoad = { [weak self] in
            self?.setViewState(.read)
            self?.view?.startActivity()
            
            self?.interactor.requestUserData { result in
                self?.view?.stopActivity()
                
                result.onData {
                    self?.view?.setRightButtonEnabled(true)
                }
                result.onError { error in
                    self?.view?.showError(error)
                }
            }
        }
    }
    
    private func validateDataAndShowError(to field: InputField) {
        interactor.validateData { [weak self] result in
            switch result {
            case .correct:
                self?.view?.setRightButtonEnabled(true)
                self?.view?.setState(.normal, to: field)
            case .incorrect(let errors):
                self?.view?.setRightButtonEnabled(false)
                let error = errors.first(where: { $0.field == field })
                self?.view?.setState(error == nil ? .normal : .validationError, to: field)
            }
        }
    }
    
    private func setViewState(_ viewState: ViewState) {
        switch viewState {
        case .edit:
            view?.setInputFieldsEnabled(true)
            view?.setAvatarSelectionEnabled(true)
            view?.setAddPhotoTitleVisible(true)
            view?.setRightButton(title: "Сохранить") { [weak self] in
                self?.view?.startActivity()
                
                self?.interactor.saveChanges { [weak self] result in
                    self?.view?.stopActivity()
                    result.onData {
                        self?.setViewState(.read)
                    }
                    result.onError { networkRequestError in
                        self?.view?.showError(networkRequestError)
                    }
                }
            }
        case .read:
            view?.setInputFieldsEnabled(false)
            view?.setAvatarSelectionEnabled(false)
            view?.setAddPhotoTitleVisible(false)
            view?.setRightButton(title: "Изменить") { [weak self] in
                self?.setViewState(.edit)
                self?.view?.setRightButtonEnabled(false)
            }
        }
    }
    
    private func presentUser(_ user: User) {
        view?.setAvatarImageUrl(user.avatar.flatMap { URL.init(string: $0.image) })
        view?.setInputValue(field: .name, value: user.name)
        view?.setInputValue(field: .email, value: user.email)
        view?.setInputValue(field: .phone, value: user.phone)
    }
    
    private func showAddPhotoActionSheet() {
        let actionSheet = StandardAlert(type: .actionSheet)
        
        actionSheet.cancelButton = StandardAlert.Button("Отмена".uppercased(), type: .cancel)
        
        let takePhotoButton = StandardAlert.Button("Сделать фото".uppercased(), type: .custom) { [weak self] in
            self?.takeAvatarPhoto()
        }
        actionSheet.buttons.append(takePhotoButton)
        
        let selectPhotoButton = StandardAlert.Button("Выбрать из галереи".uppercased(), type: .custom) { [weak self] in
            self?.selectAvatarPhoto()
        }
        actionSheet.buttons.append(selectPhotoButton)
        
        view?.showAlert(actionSheet)
    }
    
    private func takeAvatarPhoto() {
        router.showCamera { [weak self] cameraModule in
            let module = cameraModule
            cameraModule.onFinish = { [weak module] result in
                switch result {
                case .finished(let photo):
                    self?.setAvatarImage(photo)
                case .cancelled:
                    break
                }
                
                module?.dismissModule()
            }
        }
    }
    
    private func selectAvatarPhoto() {
        view?.setUserInteractionEnabled(false)
        router.showPhotoLibrary(maxSelectedItemsCount: 1) { photoLibraryModule in
            view?.setUserInteractionEnabled(true)
            weak var weakPhotoLibraryModule = photoLibraryModule
            photoLibraryModule.onFinish = { [weakPhotoLibraryModule] result in
                switch result {
                case .selectedItems(let items):
                    let options = ImageRequestOptions(
                        size: .fitSize(SpecSizes.avatarImageNativeSize()),
                        deliveryMode: .best
                    )
                    items.first?.image.requestImage(options: options) { [weak self] (image: UIImage?) in
                        guard let image = image else { return }
                        self?.setAvatarImage(image)
                    }
                case .cancelled:
                    break
                }
                
                weakPhotoLibraryModule?.dismissModule()
            }
        }
    }
    
    private func setAvatarImage(_ image: UIImage) {
        interactor.setAvatar(image)
        
        let croppedAvatar = image.imageByScalingAndCropping(
            SpecSizes.avatarImageNativeSize()
        )
        
        view?.setAvatarPhotoImage(croppedAvatar)
        
        view?.setAddPhotoTitleVisible(false)
    }
    
    // MARK: - UserProfileModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
}
