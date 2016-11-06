protocol ApplicationRouter: class {
    func showLoginOrRegister(configure: (_ module: LoginOrRegisterModule) -> ())
    func showLogin(configure: (_ module: LoginModule) -> ())
}
