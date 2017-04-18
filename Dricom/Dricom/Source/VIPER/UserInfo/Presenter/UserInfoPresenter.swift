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
        let user = interactor.obtainUser()
        
        view?.setCallButtonTitle("Позвонить")
        view?.setMessageButtonTitle("Написать")
        view?.setUserConnectionHint("Свяжитесь с пользователем удобным для вас способом")
        
        updateFavoritesStatus()
        
        view?.onMessageButtonTap = { [weak self] in
            self?.sendMessage(to: user)
        }
        
        view?.onCallButtonTap = { [weak self] in
            // TODO:
            print("Call the man")
        }
        
        view?.onCloseTap = { [weak self] in
            self?.dismissModule()
        }
        
        view?.onViewDidLoad = { [weak self] in
            self?.presentUser(user)
        }
    }
    
    private func presentUser(_ user: User) {
        view?.setName(user.name)
        
        view?.setAvatarImageUrl(
            user.avatar.flatMap{ URL(string: $0.image) }
        )
        
        if let licenseNumber = user.licenses.first?.title,
            let licenseParts = LicenseParts(licenseNumber: licenseNumber) {
            view?.setLicenseParts(licenseParts)
        }
    }
    
    private func updateFavoritesStatus() {
        // TODO:
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
