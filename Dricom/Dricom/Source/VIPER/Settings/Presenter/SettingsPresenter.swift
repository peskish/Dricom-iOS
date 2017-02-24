import Foundation

final class SettingsPresenter:
    SettingsModule
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
    
    // MARK: - Private
    private func setUpView() {
        
    }
    
    // MARK: - SettingsModule
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    var onFinish: ((SettingsResult) -> ())?
}
