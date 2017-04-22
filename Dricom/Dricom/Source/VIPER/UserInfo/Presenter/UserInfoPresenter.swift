import Foundation

final class UserInfoPresenter: UserInfoModule {
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
        let userInfo = interactor.obtainUserInfo()
        
        view?.setCallButtonTitle("Позвонить")
        view?.setMessageButtonTitle("Написать")
        view?.setUserConnectionHint("Свяжитесь с пользователем удобным для вас способом")
        
        view?.onMessageButtonTap = { [weak self] in
            self?.sendMessage(to: userInfo.user)
        }
        
        view?.onCallButtonTap = { [weak self] in
            // TODO:
            print("Call the man")
        }
        
        view?.onCloseTap = { [weak self] in
            self?.dismissModule()
        }
        
        view?.onViewDidLoad = { [weak self] in
            self?.presentUserInfo(userInfo)
        }
    }
    
    private func presentUserInfo(_ userInfo: UserInfo) {
        view?.setName(userInfo.user.name)
        
        view?.setAvatarImageUrl(
            userInfo.user.avatar.flatMap{ URL(string: $0.image) }
        )
        
        if let licenseNumber = userInfo.user.licenses.first?.title,
            let licenseParts = LicenseParts(licenseNumber: licenseNumber) {
            view?.setLicenseParts(licenseParts)
        }
        
        let favoritesButtonTitle = userInfo.isInFavorites
            ? "Удалить из избранного"
            : "Добавить в избранное"
        view?.setFavoritesButtonTitle(favoritesButtonTitle)
        
        view?.onFavoritesButtonTap = { [weak self] in
            self?.view?.startActivity()
            self?.interactor.changeUserFavoritesStatus { result in
                self?.view?.stopActivity()
                result.onData {
                    guard let userInfo = self?.interactor.obtainUserInfo() else { return }
                    self?.presentUserInfo(userInfo)
                }
                result.onError { networkRequestError in
                    self?.view?.showError(networkRequestError)
                }
            }
        }
    }
    
    private func sendMessage(to user: User) {
        // TODO: открыть чат с пользователем
    }
    
    // MARK: - UserInfoModule
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    var onAddUserToFavorites: ((User) -> ())?
    var onRemoveUserFromFavorites: ((User) -> ())?
}
