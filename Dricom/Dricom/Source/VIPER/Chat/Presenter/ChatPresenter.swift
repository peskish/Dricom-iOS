import Foundation

final class ChatPresenter {
    // MARK: - Private properties
    private let interactor: ChatInteractor
    private let router: ChatRouter
    
    // MARK: - Init
    init(interactor: ChatInteractor,
         router: ChatRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: ChatViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        
    }
    
    // MARK: - ChatModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
}
