final class MainFlowController {
    // MARK: Properties
    let router: ApplicationRouter
    
    // MARK: Init
    init(router: ApplicationRouter) {
        self.router = router
    }
    
    // MARK: Flow control
    func start() {
        openLoginScreen()
    }
    
    func openLoginScreen() {
        router.showLogin { loginModule in
            loginModule.onFinish = { [weak self] result in
                if case .finished(let user) = result {
                    self?.openMainPage(user: user)
                }
            }
        }
    }
    
    func openMainPage(user: User) {
        router.showMainPage(user: user)
    }
}
