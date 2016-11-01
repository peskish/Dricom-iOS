import Foundation

final class LoginOrRegisterPresenter:
    LoginOrRegisterModule
{
    // MARK: - Private properties
    private let router: LoginOrRegisterRouter
    
    // MARK: - Init
    init(router: LoginOrRegisterRouter)
    {
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: LoginOrRegisterViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        view?.onViewDidLoad = { [weak self] in
            self?.view?.setLoginButtonTitle("Войти")
            self?.view?.setRegisterButtonTitle("Зарегистрироваться")
        }
        view?.onLoginButtonTap = {
            print("onLoginButtonTap")
        }
        view?.onRegisterButtonTap = {
            print("onRegisterButtonTap")
        }
        view?.onInfoButtonTap = {
            print("onInfoButtonTap")
        }
    }
    
    // MARK: - LoginOrRegisterModule
    var onFinish: ((LoginOrRegisterResult) -> ())?
}
