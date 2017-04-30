import Foundation

final class MainPagePresenter: MainPageModule {
    // MARK: - Private properties
    private let interactor: MainPageInteractor
    private let router: MainPageRouter
    private let searchDebouncer = Debouncer(delay: 0.5)
    
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
        view?.setScreenTitle("Автовладельцы")
        view?.setSearchPlaceholder("Найти по номеру")
        view?.setFavoritesSectionTitle("Избранные пользователи")
        view?.setNoFavoritesTitle("У вас пока нет избранных пользователей")
        view?.setNoFavoritesDescription("Вы можете воспользоваться поиском автовладельцев и добавить пользователей")
        
        view?.onViewDidLoad = { [weak self] in
            self?.updateFavoritesList(forceReload: false)
        }
        
        view?.onSearchTextChange = { [weak self] license in
            self?.searchDebouncer.debounce {
                self?.searchUsers(license: license)
            }
        }
    }
    
    private func updateFavoritesList(forceReload: Bool) {
        view?.startActivity()
        interactor.favoriteUsersList(forceReload: forceReload) { [weak self] result in
            self?.view?.stopActivity()
            self?.showFavoriteUsers(result.cachedData() ?? [])
        }
    }
    
    private func searchUsers(license: String?) {
        guard let license = license, license.characters.count > 1 else {
            view?.setUserSuggestList([])
            return
        }
        
        interactor.searchUsers(license: license) { [weak self] result in
            result.onData { userInfoList in
                guard let `self` = self else { return }
                self.view?.setUserSuggestList(userInfoList.map(self.convertToUserRowViewData))
            }
            
            result.onError { error in
                self?.view?.showError(error)
            }
        }
    }
    
    private func configureUserInfoModule(_ module: UserInfoModule) {
        module.onAddUserToFavorites = { [weak self] user in
            self?.updateFavoritesList(forceReload: false)
        }
        
        module.onRemoveUserFromFavorites = { [weak self] user in
            self?.updateFavoritesList(forceReload: false)
        }
    }
    
    private func showFavoriteUsers(_ users: [User]) {
        view?.setFavorites(
            users.map { user -> UserRowViewData in
                return UserRowViewData(
                    id: user.id,
                    avatarImageUrl: user.avatar.flatMap { URL(string: $0.image) },
                    name: user.name,
                    license: user.licenses.first?.title,
                    isInFavorites: true,
                    onTap: { [weak self] in
                        let userInfo = UserInfo(user: user, isInFavorites: true)
                        self?.router.showUserInfo(userInfo) { userInfoModule in
                            self?.configureUserInfoModule(userInfoModule)
                        }
                    }
                )
            }
        )
    }
    
    private func convertToUserRowViewData(_ userInfo: UserInfo) -> UserRowViewData {
        return UserRowViewData(
            id: userInfo.user.id,
            avatarImageUrl: userInfo.user.avatar.flatMap { URL(string: $0.image) },
            name: userInfo.user.name,
            license: userInfo.user.licenses.first?.title,
            isInFavorites: userInfo.isInFavorites,
            onTap: { [weak self] in
                self?.router.showUserInfo(userInfo) { userInfoModule in
                    self?.configureUserInfoModule(userInfoModule)
                }
            }
        )
    }
    
    // MARK: - MainPageModule
    func presentUser(_ user: User) {
        let licenseParts = LicenseParts(licenseNumber: user.licenses.first?.title)
        view?.setAccountViewData(
            AccountViewData(
                avatarImageUrl: user.avatar.flatMap{ URL(string: $0.image) },
                name: user.name,
                license: licenseParts.flatMap { $0.parts.joined(separator: " ") }
            )
        )
    }
    
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
}
