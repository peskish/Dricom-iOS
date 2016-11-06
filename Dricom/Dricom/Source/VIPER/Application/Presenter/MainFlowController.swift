final class MainFlowController {
    // MARK: Properties
    let router: ApplicationRouter
    
    // MARK: Init
    init(router: ApplicationRouter) {
        self.router = router
    }
    
    // MARK: Flow control
    func start() {
        router.showLoginOrRegister { loginOrRegisterModule in
            loginOrRegisterModule.onFinish = { [weak self] loginOrRegisterResult in
                switch loginOrRegisterResult {
                case .login:
                    self?.openLoginScreen()
                case .register:
                    self?.openRegisterScreen()
                }
            }
        }
    }
    
    func openLoginScreen() {
        router.showLogin { loginModule in
            loginModule.onFinish = { [weak self] _ in
                self?.openMainPage()
            }
        }
    }
    
    func openRegisterScreen() {
        print("Open register screen")
    }
    
    func openMainPage() {
        print("Open main page")
    }
}
