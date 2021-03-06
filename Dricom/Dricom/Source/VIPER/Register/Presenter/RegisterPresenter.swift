import Paparazzo
import ImageSource
import Photos

final class RegisterPresenter: RegisterModule {
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
        view?.setViewTitle("Регистрация".uppercased())
        view?.setAddPhotoTitle("Добавить фото")
        view?.setRegisterButtonTitle("Зарегистрироваться")
        
        view?.setInputPlaceholder(field: .name, placeholder: "Ваше имя")
        view?.setInputPlaceholder(field: .email, placeholder: "Ваш Email")
        view?.setInputPlaceholder(field: .license, placeholder: "Номер автомобиля")
        view?.setInputPlaceholder(field: .phone, placeholder: "Контактный телефон")
        view?.setInputPlaceholder(field: .password, placeholder: "Введите пароль")
        view?.setInputPlaceholder(field: .passwordConfirmation, placeholder: "Повторите пароль")
        
        view?.setOnInputChange(field: .name) { [weak self] text in
            self?.interactor.setName(text)
            let error = self?.interactor.validateName()
            self?.view?.setState(error == nil ? .normal : .validationError, to: .name)
        }
        
        view?.setOnInputChange(field: .email) { [weak self] text in
            self?.interactor.setEmail(text)
            let error = self?.interactor.validateEmail()
            self?.view?.setState(error == nil ? .normal : .validationError, to: .email)
        }
        
        view?.setOnInputChange(field: .phone) { [weak self] text in
            self?.interactor.setPhone(text)
            let error = self?.interactor.validatePhone()
            self?.view?.setState(error == nil ? .normal : .validationError, to: .phone)
        }
        
        view?.setOnInputChange(field: .license) { [weak self] text in
            self?.interactor.setLicense(text)
            let error = self?.interactor.validateLicense()
            self?.view?.setState(error == nil ? .normal : .validationError, to: .license)
        }
        
        view?.setOnInputChange(field: .password) { [weak self] text in
            self?.interactor.setPassword(text)
            let error = self?.interactor.validatePassword()
            self?.view?.setState(error == nil ? .normal : .validationError, to: .password)
        }
        
        view?.setOnInputChange(field: .passwordConfirmation) { [weak self] text in
            self?.interactor.setPasswordConfirmation(text)
            self?.view?.setState(.normal, to: .passwordConfirmation)
        }
        
        view?.setOnDoneButtonTap(field: .name) { [weak self] in
            self?.view?.focusOnField(.email)
        }
        
        view?.setOnDoneButtonTap(field: .email) { [weak self] in
            self?.view?.focusOnField(.license)
        }
        
        view?.setOnDoneButtonTap(field: .license) { [weak self] in
            self?.view?.focusOnField(.phone)
        }
        
        view?.setOnDoneButtonTap(field: .phone) { [weak self] in
            self?.view?.focusOnField(.password)
        }
        
        view?.setOnDoneButtonTap(field: .password) { [weak self] in
            self?.view?.focusOnField(.passwordConfirmation)
        }
        
        view?.setOnDoneButtonTap(field: .passwordConfirmation) { [weak self] in
            self?.view?.endEditing()
        }
        
        view?.onAddPhotoButtonTap = { [weak self] in
            self?.showAddPhotoActionSheet()
        }
        
        view?.onRegisterButtonTap = { [weak self] in
            self?.validateDataAndProceed()
        }
    }
    
    private func validateDataAndProceed() {
        view?.endEditing()
        interactor.validateData { [weak self] validationResult in
            switch validationResult {
            case .correct:
                self?.view?.setStateAccordingToErrors([])
                self?.proceedRegistration()
            case .incorrect(let errors):
                self?.showValidationErrors(errors)
            }
        }
    }
    
    private func proceedRegistration() {
        view?.startActivity()
        interactor.registerUser { [weak self] result in
            self?.view?.stopActivity()
            result.onData {
                self?.onFinish?(.finished)
            }
            result.onError { networkRequestError in
                self?.view?.showError(networkRequestError)
            }
        }
    }
    
    private func showValidationErrors(_ errors: [InputFieldError]) {
        view?.setStateAccordingToErrors(errors)
        
        let validationErrors: [String] = errors.flatMap {
            if case .incorrectData(let message) = $0.errorType {
                return message
            } else {
                return nil
            }
        }
        
        if !validationErrors.isEmpty {
            let cancelButton = StandardAlert.Button("OK", type: .cancel) { [weak self] in
                self?.view?.focusOnField(errors.first?.field)
            }
            
            let alert = StandardAlert(
                title: "Пожалуйста, исправьте:",
                message: validationErrors.joined(separator: "\n"),
                cancelButton: cancelButton
            )
            
            view?.showAlert(alert)
        } else {
            view?.focusOnField(errors.first?.field)
        }
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
        
        view?.setAddPhotoButtonVisible(false)
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
