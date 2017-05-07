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
            self?.validateDataAndShowError(to: .oldPassword)
        }
        
        view?.setOnInputChange(field: .password) { [weak self] text in
            self?.interactor.setPassword(text)
            self?.validateDataAndShowError(to: .password)
        }
        
        view?.setOnInputChange(field: .passwordConfirmation) { [weak self] text in
            self?.interactor.setPasswordConfirmation(text)
            self?.validateDataAndShowError(to: .passwordConfirmation)
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
            self?.view?.startActivity()
            self?.interactor.changePassword { [weak self] result in
                self?.view?.stopActivity()
                result.onData { success in
                    if success {
                        self?.dismissModule()
                    } else {
                        self?.view?.showError(.internalServerError)
                    }
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
                self?.view?.setConfirmButtonEnabled(true)
                self?.view?.setState(.normal, to: field)
            case .incorrect(let errors):
                self?.view?.setConfirmButtonEnabled(false)
                let error = errors.first(where: { $0.field == field })
                self?.view?.setState(error == nil ? .normal : .validationError, to: field)
            }
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
