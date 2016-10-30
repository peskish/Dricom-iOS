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
        
    }
    
    // MARK: - LoginOrRegisterModule
    var onFinish: ((LoginOrRegisterResult) -> ())?
}
