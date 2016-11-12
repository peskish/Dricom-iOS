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
        view?.setLoginPlaceholder("Имя пользователя")
        view?.setPasswordPlaceholder("Введите пароль")
        view?.setLoginButtonTitle("Войти")
        view?.setRegisterButtonTitle("Зарегистрироваться")
        
        view?.onLoginChange = { [weak self] text in
            self?.view?.setLoginFieldState(.normal)
            self?.login = text
        }
        
        view?.onPasswordChange = { [weak self] text in
            self?.view?.setPasswordFieldState(.normal)
            self?.password = text
        }
        
        view?.onLoginButtonTap = { [weak self] in
            self?.view?.endEditing()
            self?.checkFieldsAndProceed(login: self?.login, password: self?.password)
        }
        
        view?.onRegisterButtonTap = { [weak self] in
            print("open register screen")
        }
        
        view?.onInfoButtonTap = { [weak self] in
            self?.router.showFeedback()
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
        interactor.login(userName: login, password: password) { [weak self] result in
            result.onData { _ in
                self?.onFinish?(.finished)
            }
            result.onError { networkError in
                self?.view?.showError(networkError: networkError)
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
