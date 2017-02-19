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
        
        if let licenseNumber = user.license, let licenseParts = LicenseParts(licenseNumber: licenseNumber) {
            view?.setLicenseParts(licenseParts)
        }
    }
    
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
}
