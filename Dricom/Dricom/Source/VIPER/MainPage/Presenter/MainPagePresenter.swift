import Foundation

final class MainPagePresenter {
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
        
        view?.onViewDidLoad = { [weak self] in
            self?.fetchAndPresentData()
        }
    }
    
    private func fetchAndPresentData() {
        interactor.user { [weak self] user in
            self?.view?.setName(user.userName)
            
            self?.view?.setAvatarImageUrl(
                user.avatar.flatMap{ URL(string: $0) }
            )
            
            self?.view?.setLicenseParts(
                LicenseParts(
                    firstLetter: "A ",
                    numberPart: "245",
                    restLetters: " MN",
                    regionCode: "197",
                    countryCode: "RUS"
                )
            )
        }
    }
    
    // MARK: - MainPageModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
}
