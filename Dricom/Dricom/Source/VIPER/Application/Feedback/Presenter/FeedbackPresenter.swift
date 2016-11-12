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
        view?.setSupportButtonTitle("Сообщить о проблеме")
        view?.setFeedbackButtonTitle("Обратная связь")
        
        view?.onCloseButtonTap = { [weak self] in
            self?.onFinish?(.finished)
        }
        
        view?.onFbButtonTap = { [weak self] in
            self?.interactor.openFb()
        }
        
        view?.onVkButtonTap = { [weak self] in
            self?.interactor.openVk()
        }
        
        view?.onInstagramButtonTap = { [weak self] in
            self?.interactor.openInstagram()
        }
        
        view?.onFeedbackButtonTap = { [weak self] in
            print("open mail with feedback")
        }
        
        view?.onSupportButtonTap = { [weak self] in
            print("open mail with support info")
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
