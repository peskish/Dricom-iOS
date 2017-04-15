import Foundation

final class UserInfoPresenter:
    UserInfoModule
{
    // MARK: - Private properties
    private let interactor: UserInfoInteractor
    private let router: UserInfoRouter
    
    // MARK: - Init
    init(interactor: UserInfoInteractor,
         router: UserInfoRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: UserInfoViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        
    }
    
    // MARK: - UserInfoModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    var onFinish: ((UserInfoResult) -> ())?
}
