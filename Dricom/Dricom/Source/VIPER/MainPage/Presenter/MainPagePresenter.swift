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
    }
    
    // MARK: - MainPageModule
    func setUser(_ user: User) {
        view?.setName(user.name)
        
        view?.setAvatarImageUrl(
            user.avatar.flatMap{ URL(string: $0) }
        )
        
        view?.setLicenseParts(
            LicenseParts(
                firstLetter: "A ",
                numberPart: "245",
                restLetters: " MN",
                regionCode: "197",
                countryCode: "RUS"
            )
        )
    }
    
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
}
