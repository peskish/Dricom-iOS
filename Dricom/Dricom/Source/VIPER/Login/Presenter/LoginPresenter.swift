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
        view?.onViewDidLoad = { [weak self] in
            self?.view?.setLoginPlaceholder("Имя пользователя")
            self?.view?.setPasswordPlaceholder("Введите пароль")
            self?.view?.setLoginButtonTitle("Войти")
            
            self?.view?.onLoginChange = { [weak self] text in
                self?.login = text
            }
            
            self?.view?.onPasswordChange = { [weak self] text in
                self?.password = text
            }
            
            self?.view?.onLoginButtonTap = {
                print("login button pressed")
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
