import Foundation

final class NoUserFoundPresenter:
    NoUserFoundModule
{
    // MARK: - Private properties
    private let interactor: NoUserFoundInteractor
    private let router: NoUserFoundRouter
    
    // MARK: - Init
    init(interactor: NoUserFoundInteractor,
         router: NoUserFoundRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: NoUserFoundViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        
    }
    
    // MARK: - NoUserFoundModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    var onFinish: ((NoUserFoundResult) -> ())?
}
