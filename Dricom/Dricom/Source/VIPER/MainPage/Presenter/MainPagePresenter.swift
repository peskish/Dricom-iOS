import Foundation

final class MainPagePresenter {
    // MARK: - Private properties
    private let interactor: MainPageInteractor
    private let router: MainPageRouter
    
    // MARK: - Init
    init(interactor: MainPageInteractor,
         router: MainPageRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: MainPageViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        view?.onViewDidLoad = { [weak self] in
            self?.fetchAndPresentData()
        }
    }
    
    private func fetchAndPresentData() {
        interactor.user { [weak self] user in
            self?.view?.setAvatarImageUrl(
                user.avatar.flatMap{ URL(string: $0) }
            )
        }
    }
    
    // MARK: - MainPageModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
}
