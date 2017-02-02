import Foundation

final class ApplicationPresenter {
    // MARK: - Private properties
    private let interactor: ApplicationInteractor
    private let router: ApplicationRouter
    
    // MARK: - Init
    init(interactor: ApplicationInteractor,
         router: ApplicationRouter)
    {
        self.interactor = interactor
        self.router = router
    }
}
