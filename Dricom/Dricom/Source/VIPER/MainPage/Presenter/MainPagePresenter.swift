import Foundation

final class MainPagePresenter: MainPageModule {
    // MARK: - Private properties
    private let interactor: MainPageInteractor
    private let router: MainPageRouter
    
    // MARK: - Init
    init(interactor: MainPageInteractor,
         router: MainPageRouter)
    {
        self.interactor = interactor
        self.router = router
        
        interactor.onAccountDataReceived = { [weak self] user in
            self?.presentUser(user)
        }
    }
    
    // MARK: - Weak properties
    weak var view: MainPageViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        view?.setLicenseSearchPlaceholder("Введите номер автомобиля")
        view?.setLicenseSearchTitle("Найти пользователя")
        
        view?.onViewDidLoad = { [weak self] in
            self?.view?.startActivity()
            self?.interactor.favoriteUsersList { result in
                self?.view?.stopActivity()
                self?.showFavoriteUsers(result.cachedData() ?? [])
            }
        }
        
        view?.onLicenseSearchChange = { [weak self] license in
            self?.view?.setSearchButtonEnabled(!isEmptyOrNil(license))
        }
        
        view?.setOnSearchButtonTap { [weak self] license in
            self?.searchUser(license: license)
        }
    }
    
    private func searchUser(license: String?) {
        guard let license = license else { return }
        
        view?.startActivity()
        interactor.searchUser(license: license) { [weak self] result in
            self?.view?.stopActivity()
            
            result.onData { userInfo in
                if let userInfo = userInfo {
                    self?.router.showUserInfo(userInfo) { userInfoModule in
                        userInfoModule.onAddUserToFavorites = { user in
                            print("added to favorites: \(user.id)")
                        }
                        
                        userInfoModule.onRemoveUserFromFavorites = { user in
                            print("removed from favorites: \(user.id)")
                        }
                    }
                } else {
                    self?.router.showNoUserFound()
                }
            }
            
            result.onError { error in
                self?.view?.showError(error)
            }
        }
    }
    
    private func showFavoriteUsers(_ users: [User]) {
        print("showFavoriteUsers: \(users)")
    }
    
    // MARK: - MainPageModule
    func presentUser(_ user: User) {
        view?.setName(user.name)
        
        view?.setAvatarImageUrl(
            user.avatar.flatMap{ URL(string: $0.image) }
        )
        
        if let licenseNumber = user.licenses.first?.title,
            let licenseParts = LicenseParts(licenseNumber: licenseNumber) {
            view?.setLicenseParts(licenseParts)
        }
    }
    
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
}
