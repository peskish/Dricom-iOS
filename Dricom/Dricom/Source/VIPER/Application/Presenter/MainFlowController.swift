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
            loginOrRegisterModule.onFinish = { loginOrRegisterResult in
                switch loginOrRegisterResult {
                case .Login:
                    print("Login")
                    break
                case .Register:
                    print("Register")
                    break
                }
            }
        }
    }
}
