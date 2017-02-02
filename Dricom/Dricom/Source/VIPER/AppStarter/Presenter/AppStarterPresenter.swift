import Foundation

protocol AppStarterModule {
    func handleApplicationDidFinishLaunching()
}


final class AppStarterPresenter: AppStarterModule {
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
    
    // MARK: - Weak properties
    weak var view: AppStarterViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        
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
                if case .finished(let user) = result {
                    self?.openMainPage(user: user)
                }
            }
        }
    }
    
    func openMainPage(user: User) {
        router.showMainPage(user: user)
    }
}
