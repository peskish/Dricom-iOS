import Foundation

final class ChangePasswordPresenter:
    ChangePasswordModule
{
    // MARK: - Private properties
    private let interactor: ChangePasswordInteractor
    private let router: ChangePasswordRouter
    
    // MARK: - Init
    init(interactor: ChangePasswordInteractor,
         router: ChangePasswordRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: ChangePasswordViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        view?.setScreenTitle("Изменить пароль")
        
        view?.setCancelButtonTitle("Отменить")
        view?.onCancelButtonTap = { [weak self] in
            self?.dismissModule()
        }
        
        view?.setInputPlaceholder(field: .oldPassword, placeholder: "Введите старый пароль")
        view?.setInputPlaceholder(field: .password, placeholder: "Введите новый пароль")
        view?.setInputPlaceholder(field: .passwordConfirmation, placeholder: "Повторите пароль")
        
        view?.setOnInputChange(field: .oldPassword) { [weak self] text in
            self?.interactor.setOldPassword(text)
            let error = self?.interactor.validateOldPassword()
            self?.view?.setState(error == nil ? .normal : .validationError, to: .oldPassword)
        }
        
        view?.setOnInputChange(field: .password) { [weak self] text in
            self?.interactor.setPassword(text)
            let error = self?.interactor.validatePassword()
            self?.view?.setState(error == nil ? .normal : .validationError, to: .password)
        }
        
        view?.setOnInputChange(field: .passwordConfirmation) { [weak self] text in
            self?.interactor.setPasswordConfirmation(text)
            let error = self?.interactor.validatePasswordConfirmation()
            self?.view?.setState(error == nil ? .normal : .validationError, to: .passwordConfirmation)
        }
        
        view?.setOnDoneButtonTap(field: .oldPassword) { [weak self] in
            self?.view?.focusOnField(.password)
        }
        
        view?.setOnDoneButtonTap(field: .password) { [weak self] in
            self?.view?.focusOnField(.passwordConfirmation)
        }
        
        view?.setOnDoneButtonTap(field: .passwordConfirmation) { [weak self] in
            self?.view?.endEditing()
        }
        
        view?.setConfirmButtonTitle("Подтвердить")
        view?.setConfirmButtonEnabled(false)
        view?.onConfirmButtonTap = { [weak self] in
            // TODO:
            print("onConfirmButtonTap")
        }
    }
    
    // MARK: - ChangePasswordModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    var onFinish: ((ChangePasswordResult) -> ())?
}
