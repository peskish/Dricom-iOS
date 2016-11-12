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
            loginModule.onFinish = { [weak self] _ in
                self?.openMainPage()
            }
        }
    }
    
    func openMainPage() {
        print("Open main page")
    }
}
