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
        
        interactor.onUserDataReceived = { [weak self] user in
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
