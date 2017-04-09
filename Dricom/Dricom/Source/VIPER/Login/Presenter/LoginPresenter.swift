import Foundation

final class LoginPresenter:
    LoginModule
{
    // MARK: - Private properties
    private let interactor: LoginInteractor
    private let router: LoginRouter
    
    // MARK: - State
    private var login: String?
    private var password: String?
    
    // MARK: - Init
    init(interactor: LoginInteractor,
         router: LoginRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: LoginViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        view?.setLoginPlaceholder("Email, телефон или номер автомобиля")
        view?.setPasswordPlaceholder("Введите пароль")
        view?.setLoginButtonTitle("Войти")
        view?.setRegisterButtonTitle("Регистрация")
        
        view?.onLoginChange = { [weak self] text in
            self?.view?.setLoginFieldState(.normal)
            self?.login = text
        }
        
        view?.onPasswordChange = { [weak self] text in
            self?.view?.setPasswordFieldState(.normal)
            self?.password = text
        }
        
        view?.onLoginButtonTap = { [weak self] in
            self?.checkFieldsAndProceed(login: self?.login, password: self?.password)
        }
        
        view?.onRegisterButtonTap = { [weak self] in
            self?.view?.endEditing()
            self?.router.showRegister { registerModule in
                registerModule.onFinish = { result in
                    if case .finished = result {
                        self?.onFinish?(.finished)
                    }
                }
            }
        }
    }
    
    private func checkFieldsAndProceed(login: String?, password: String?) {
        var focusOnErrorFieldWasSet = false
        
        if let login = login, let password = password {
            proceed(login: login, password: password)
            return
        }
        
        if login == nil {
            focusOnErrorFieldWasSet = true
            
            view?.focusOnLoginField()
            view?.setLoginFieldState(.validationError)
        }
        
        if password == nil {
            if !focusOnErrorFieldWasSet {
                view?.focusOnPasswordField()
            }
            view?.setPasswordFieldState(.validationError)
        }
    }
    
    private func proceed(login: String, password: String) {
        view?.endEditing()
        view?.startActivity()
        interactor.login(username: login, password: password) { [weak self] result in
            self?.view?.stopActivity()
            result.onData { user in
                self?.onFinish?(.finished)
            }
            result.onError { networkRequestError in
                switch networkRequestError {
                case .userIsNotAuthorized:
                    self?.view?.showErrorMessage("Неверное имя пользователя или пароль")
                default:
                    self?.view?.showError(networkRequestError)
                }
            }
        }
    }
    
    // MARK: - LoginModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    var onFinish: ((LoginResult) -> ())?
    
    // MARK: ViewControllerPositionHolder
    var position: ViewControllerPosition? {
        get { return view?.position }
        set { view?.position = newValue }
    }
}
