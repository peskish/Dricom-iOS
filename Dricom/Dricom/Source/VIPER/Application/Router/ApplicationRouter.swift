protocol ApplicationRouter: class {
    func showLoginOrRegister(configure: (_ module: LoginOrRegisterModule) -> ())
}
