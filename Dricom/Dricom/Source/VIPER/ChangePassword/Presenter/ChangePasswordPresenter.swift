import Foundation

final class ChangePasswordPresenter:
    ChangePasswordModule
{
    // MARK: - Private properties
    private let interactor: ChangePasswordInteractor
    private let router: ChangePasswordRouter
    
    // MARK: - Init
    init(interactor: ChangePasswordInteractor,
         router: ChangePasswordRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: ChangePasswordViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        
    }
    
    // MARK: - ChangePasswordModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    var onFinish: ((ChangePasswordResult) -> ())?
}
