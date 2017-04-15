import Foundation

final class NoUserFoundPresenter {
    // MARK: - Private properties
    private let router: NoUserFoundRouter
    
    // MARK: - Init
    init(router: NoUserFoundRouter) {
        self.router = router
    }
    
    // MARK: - Weak properties
    weak var view: NoUserFoundViewInput? {
        didSet {
            setUpView()
        }
    }
    
    // MARK: - Private
    private func setUpView() {
        view?.setMessage("Упс! Такого пользователя нет")
        view?.setDescription("Найдите автомобилиста в реальном мире и предложите воспользоваться данным приложением")
        view?.onCloseTap = { [weak self] in
            self?.dismissModule()
        }
    }
    
    private func dismissModule() {
        router.dismissCurrentModule()
    }
}
