import Foundation

protocol ApplicationLaunchHandler {
    func handleApplicationDidFinishLaunching()
}

final class ApplicationPresenter: ApplicationLaunchHandler {
    // MARK: - Private properties
    private let interactor: ApplicationInteractor
    private let router: ApplicationRouter
    
    weak var view: ApplicationViewInput?
    weak var mainPageModule: MainPageModule?
    
    // MARK: - Init
    init(interactor: ApplicationInteractor,
         router: ApplicationRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - ApplicationLaunchHandler
    func handleApplicationDidFinishLaunching() {
        guard let view = view else { return }
        
        router.showAppStarter(disposeBag: view.disposeBag, mainPageModule: mainPageModule) { applicationLaunchHandler in
            applicationLaunchHandler.handleApplicationDidFinishLaunching()
        }
    }
}
