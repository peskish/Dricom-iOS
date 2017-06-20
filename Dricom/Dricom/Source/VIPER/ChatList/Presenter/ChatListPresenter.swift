import Foundation

final class ChatListPresenter:
    ChatListModule
{
    // MARK: - Private properties
    private let interactor: ChatListInteractor
    private let router: ChatListRouter
    
    // MARK: - Init
    init(interactor: ChatListInteractor,
         router: ChatListRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: ChatListViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        
    }
    
    // MARK: - ChatListModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    var onFinish: ((ChatListResult) -> ())?
}
