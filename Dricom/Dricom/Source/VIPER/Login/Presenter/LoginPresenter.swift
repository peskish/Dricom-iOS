import Foundation

final class LoginPresenter:
    LoginModule
{
    // MARK: - Private properties
    private let interactor: LoginInteractor
    private let router: LoginRouter
    
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
        
    }
    
    // MARK: - LoginModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    var onFinish: ((LoginResult) -> ())?
}
