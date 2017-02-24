import Foundation

protocol ApplicationLaunchHandler {
    func handleApplicationDidFinishLaunching()
}

protocol UserSettable: class {
    func setUser(_ user: User)
}

final class ApplicationPresenter: ApplicationLaunchHandler, UserSettable {
    // MARK: - Private properties
    private let interactor: ApplicationInteractor
    private let router: ApplicationRouter
    
    weak var view: ApplicationViewInput?
    weak var mainPageModule: MainPageModule?
    weak var settingsModule: SettingsModule?
    
    // MARK: - Init
    init(interactor: ApplicationInteractor,
         router: ApplicationRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - UserSettable
    func setUser(_ user: User) {
        let modules: [UserSettable?] = [mainPageModule, settingsModule]
        modules.flatMap{ $0 }.forEach({ $0.setUser(user) })
    }
    
    // MARK: - ApplicationLaunchHandler
    func handleApplicationDidFinishLaunching() {
        guard let view = view else { return }
        
        router.showAppStarter(disposeBag: view.disposeBag, userSettable: self) { applicationLaunchHandler in
            applicationLaunchHandler.handleApplicationDidFinishLaunching()
        }
    }
}
