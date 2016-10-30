import Foundation

protocol ApplicationEventsHandler: class {
    func handleApplicationDidFinishLaunching()
}

final class ApplicationPresenter: ApplicationEventsHandler
{
    // MARK: - Private properties
    private let interactor: ApplicationInteractor
    private let router: ApplicationRouter
    private let mainFlowController: MainFlowController
    
    // MARK: - Init
    init(interactor: ApplicationInteractor,
         router: ApplicationRouter)
    {
        self.interactor = interactor
        self.router = router
        
        mainFlowController = MainFlowController(router: router)
    }
    
    // MARK: - ApplicationEventsHandler
    func handleApplicationDidFinishLaunching() {
        mainFlowController.start()
    }
}
