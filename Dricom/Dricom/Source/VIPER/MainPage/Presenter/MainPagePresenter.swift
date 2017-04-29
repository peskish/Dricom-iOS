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
                
                self.view?.setUserSuggestList(userInfoList.map(self.convertToFavoriteUserViewData))
                
                self.view?.onUserSuggestTap = { [weak self] userId in
                    guard let userInfo = userInfoList.first(where: { $0.user.id == userId }) else { return }
                    
                    self?.router.showUserInfo(userInfo) { userInfoModule in
                        userInfoModule.onAddUserToFavorites = { user in
                            self?.updateFavoritesList(forceReload: false)
                        }
                        
                        userInfoModule.onRemoveUserFromFavorites = { user in
                            self?.updateFavoritesList(forceReload: false)
                        }
                    }
                }
            }
            
            result.onError { error in
                self?.view?.showError(error)
            }
        }
    }
    
    private func showFavoriteUsers(_ users: [User]) {
        view?.setFavorites(
            users.map {
                UserViewData(
                    id: $0.id,
                    avatarUrl: $0.avatar?.image,
                    name: $0.name,
                    license: $0.licenses.first?.title,
                    isInFavorites: true
                )
            }
        )
    }
    
    private func convertToFavoriteUserViewData(_ userInfo: UserInfo) -> UserViewData {
        return UserViewData(
            id: userInfo.user.id,
            avatarUrl: userInfo.user.avatar?.image,
            name: userInfo.user.name,
            license: userInfo.user.licenses.first?.title,
            isInFavorites: userInfo.isInFavorites
        )
    }
    
    // MARK: - MainPageModule
    func presentUser(_ user: User) {
        let license: String?
        if let parts = LicenseParts(licenseNumber: user.licenses.first?.title) {
            license = parts.firstLetter
                + parts.numberPart
                + parts.restLetters
                + " "
                + parts.regionCode
                + parts.countryCode
        } else {
            license = nil
        }
        
        view?.setAccountViewData(
            AccountViewData(
                name: user.name,
                avatarImageUrl: user.avatar.flatMap{ URL(string: $0.image) },
                license: license
            )
        )
    }
    
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
}
