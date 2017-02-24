import Foundation

final class SettingsPresenter: SettingsModule
{
    // MARK: - Private properties
    private let interactor: SettingsInteractor
    private let router: SettingsRouter
    
    // MARK: - Init
    init(interactor: SettingsInteractor,
         router: SettingsRouter)
    {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: SettingsViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - SettingsModule
    func setUser(_ user: User) {
        // TODO:
    }
    
    // MARK: - Private
    private func setUpView() {
        view?.setViewTitle("Настройки")
    }
    
    // MARK: - SettingsModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
}
