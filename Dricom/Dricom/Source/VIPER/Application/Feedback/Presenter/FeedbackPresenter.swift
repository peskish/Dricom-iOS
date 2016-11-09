import Foundation

final class FeedbackPresenter:
    FeedbackModule
{
    // MARK: - Private properties
    private let interactor: FeedbackInteractor
    private let router: FeedbackRouter
    
    // MARK: - Init
    init(interactor: FeedbackInteractor,
         router: FeedbackRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: FeedbackViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        view?.onCloseButtonTap = { [weak self] in
            self?.onFinish?(.finished)
        }
    }
    
    // MARK: - FeedbackModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    var onFinish: ((FeedbackResult) -> ())?
}
