import Foundation

final class AppStarterPresenter: ApplicationLaunchHandler {
    // MARK: - Private properties
    private let interactor: AppStarterInteractor
    private let router: AppStarterRouter
    
    // MARK: - Init
    init(interactor: AppStarterInteractor,
         router: AppStarterRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - ApplicationLaunchHandler
    func handleApplicationDidFinishLaunching() {
        // TODO: check saved session
        openLoginScreen()
    }
    
    // MARK: Flow control
    func openLoginScreen() {
        router.showLogin { loginModule in
            loginModule.onFinish = { [weak self] result in
                if case .finished = result {
                    self?.router.dismissCurrentModule()
                }
            }
        }
    }
}
