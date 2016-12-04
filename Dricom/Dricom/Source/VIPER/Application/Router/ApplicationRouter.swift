protocol ApplicationRouter: class {
    func showLogin(configure: (_ module: LoginModule) -> ())
    func showMainPage(user: User)
}
