import Foundation

final class UserProfilePresenter:
    UserProfileModule
{
    // MARK: - Private properties
    private let interactor: UserProfileInteractor
    private let router: UserProfileRouter
    
    // MARK: - Init
    init(interactor: UserProfileInteractor,
         router: UserProfileRouter)
    {
        self.interactor = interactor
        self.router = router
        
        interactor.onUserDataReceived = { [weak self] user in
            self?.presentUser(user)
        }
    }
    
    // MARK: - Weak properties
    weak var view: UserProfileViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private enum ViewState {
        case read
        case edit
    }
    
    private func setUpView() {
        view?.setViewTitle("Профиль")
        view?.setAddPhotoTitle("Изменить фото")
        view?.setRightButtonEnabled(false)
        
        view?.onViewDidLoad = { [weak self] in
            self?.setViewState(.read)
            self?.view?.startActivity()
            
            self?.interactor.requestUserData { result in
                self?.view?.stopActivity()
                
                result.onData {
                    self?.view?.setRightButtonEnabled(true)
                }
                result.onError { error in
                    self?.view?.showError(error)
                }
            }
        }
    }
    
    private func setViewState(_ viewState: ViewState) {
        switch viewState {
        case .edit:
            view?.setInputFieldsEnabled(true)
            view?.setAvatarSelectionEnabled(true)
            view?.setAddPhotoTitleVisible(true)
            view?.setRightButton(title: "Сохранить") { [weak self] in
                self?.view?.startActivity()
                
                // TODO: call interactor
            }
        case .read:
            view?.setInputFieldsEnabled(false)
            view?.setAvatarSelectionEnabled(false)
            view?.setAddPhotoTitleVisible(false)
            view?.setRightButton(title: "Изменить") { [weak self] in
                self?.setViewState(.edit)
                self?.view?.setRightButtonEnabled(false)
            }
        }
    }
    
    private func presentUser(_ user: User) {
        view?.setAvatarImageUrl(user.avatar.flatMap { URL.init(string: $0) })
    }
    
    // MARK: - UserProfileModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
}
