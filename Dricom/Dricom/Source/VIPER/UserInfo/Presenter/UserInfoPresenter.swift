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
        
        updateFavoritesStatus()
    }
    
    private func updateFavoritesStatus() {
        // TODO:
        // обновить подпись
        // поставить колбэк во вью
    }
    
    private func sendMessage(to user: User) {
        // TODO:
    }
    
    // MARK: - UserInfoModule
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    var onAddUserToFavorites: ((User) -> ())?
    var onRemoveUserFromFavorites: ((User) -> ())?
}
