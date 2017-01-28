import CTAssetsPickerController

final class RegisterPresenter: NSObject,
    RegisterModule,
    CTAssetsPickerControllerDelegate
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
    private let addPhotoCapture = "Добавить фото"
    
    private func setUpView() {
        view?.setViewTitle("Регистрация".uppercased())
        view?.setAddPhotoTitle(addPhotoCapture)
        view?.setRegisterButtonTitle("Зарегистрироваться")
        
        view?.setInputPlaceholder(field: .name, placeholder: "Имя")
        view?.setInputPlaceholder(field: .email, placeholder: "Email")
        view?.setInputPlaceholder(field: .phone, placeholder: "Контактный телефон")
        view?.setInputPlaceholder(field: .license, placeholder: "Номер автомобиля")
        view?.setInputPlaceholder(field: .password, placeholder: "Пароль")
        view?.setInputPlaceholder(field: .passwordConfirmation, placeholder: "Подтверждение пароля")
        
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
            result.onData { _ in
                print("show main screen")
            }
            result.onError { error in
                self?.view?.showError(networkError: error)
            }
        }
    }
    
    private func showValidationErrors(_ errors: [RegisterInputFieldError]) {
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
        
        actionSheet.cancelButton = StandardAlert.Button("Отмена", type: .cancel)
        
        if interactor.hasAvatar() == true {
            let removePhotoButton = StandardAlert.Button("Удалить", type: .destructive) { [weak self] in
                self?.removeAvatarPhoto()
            }
            actionSheet.buttons.append(removePhotoButton)
        }
        
        let takePhotoButton = StandardAlert.Button("Сделать фото", type: .custom) { [weak self] in
            self?.takeAvatarPhoto()
        }
        actionSheet.buttons.append(takePhotoButton)
        
        let selectPhotoButton = StandardAlert.Button("Выбрать из галереи", type: .custom) { [weak self] in
            self?.selectAvatarPhoto()
        }
        actionSheet.buttons.append(selectPhotoButton)
        
        view?.showAlert(actionSheet)
    }
    
    private func takeAvatarPhoto() {
        router.showCamera { [weak self] cameraModule in
            let module = cameraModule
            cameraModule.onFinish = { [weak module] result in
                if case .finished(let avatar) = result {
                    self?.interactor.setAvatar(avatar)
                    self?.view?.setAvatarPhotoImage(avatar)
                    self?.view?.setAddPhotoTitle("")
                }
                
                module?.dismissModule()
            }
        }
    }
    
    private func selectAvatarPhoto() {
        router.showMediaPicker(delegate: self)
    }
    
    private func removeAvatarPhoto() {
        interactor.setAvatar(nil)
        view?.setAvatarPhotoImage(nil)
        view?.setAddPhotoTitle(addPhotoCapture)
    }
    
    // MARK: - CTAssetsPickerControllerDelegate
    func assetsPickerController(_ picker: CTAssetsPickerController!, didFinishPickingAssets assets: [Any]!) {
        if let asset = assets.first as? PHAsset {
            setAvatarImageFromAsset(asset)
        }
        
        focusOnModule()
    }
    
    func assetsPickerController(_ picker: CTAssetsPickerController!, didSelect asset: PHAsset!) {
        setAvatarImageFromAsset(asset)
        focusOnModule()
    }
    
    private func setAvatarImageFromAsset(_ asset: PHAsset) {
        let avatarThumbnail = PHAssetUtilities.getImageFrom(asset: asset)
        interactor.setAvatar(avatarThumbnail)
        
        let croppedAvatar = avatarThumbnail.imageByScalingAndCropping(SpecSizes.avatarImageSize)
        view?.setAvatarPhotoImage(croppedAvatar)
        view?.setAddPhotoTitle("")
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
