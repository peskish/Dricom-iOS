import Foundation

final class AppStarterPresenter: ApplicationLaunchHandler {
    // MARK: - Private properties
    private let interactor: AppStarterInteractor
    private let router: AppStarterRouter
    
    weak var userSettable: UserSettable?
    
    // MARK: - Init
    init(interactor: AppStarterInteractor,
         router: AppStarterRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - ApplicationLaunchHandler
    func handleApplicationDidFinishLaunching() {
        interactor.user { [weak self] result in
            result.onData { user in
                self?.userSettable?.setUser(user)
                self?.router.dismissCurrentModule()
            }
            result.onError { _ in
                self?.openLoginScreen()
            }
        }
    }
    
    // MARK: Flow control
    func openLoginScreen() {
        router.showLogin { loginModule in
            loginModule.onFinish = { [weak self] result in
                if case .finished(let user) = result {
                    self?.userSettable?.setUser(user)
                    self?.router.dismissCurrentModule()
                }
            }
        }
    }
}
