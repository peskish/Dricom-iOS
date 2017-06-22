import Foundation

final class ApplicationPresenter: ApplicationLaunchHandler, ApplicationModule, ModuleFocusable {
    // MARK: - Private properties
    private let interactor: ApplicationInteractor
    private let router: ApplicationRouter
    
    weak var view: ApplicationViewInput?
    weak var mainPageModule: MainPageModule?
    weak var chatListModule: ChatListModule?
    weak var settingsModule: SettingsModule?
    
    // MARK: - Init
    init(interactor: ApplicationInteractor,
         router: ApplicationRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - ApplicationModule
    func resetViewState() {
        for module in [mainPageModule, chatListModule, settingsModule] as [ModuleFocusable?] {
            module?.focusOnModule()
        }
        
        view?.selectTab(.mainPage)
    }
    
    func showLogin(shouldResetViewState: Bool) {
        router.showLogin { loginModule in
            loginModule.onFinish = { [weak self] result in
                if shouldResetViewState {
                    self?.resetViewState()
                }
                self?.focusOnModule()
            }
        }
    }
    
    // MARK: - ApplicationLaunchHandler
    func handleApplicationDidFinishLaunching() {
        guard let view = view else { return }
        
        router.showAppStarter(disposeBag: view.disposeBag) { applicationLaunchHandler in
            applicationLaunchHandler.handleApplicationDidFinishLaunching()
        }
    }
    
    // MARK: - ModuleFocusable
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
}
