protocol ApplicationRouter: class, RouterFocusable {
    func showAppStarter(
        disposeBag: DisposeBag,
        completion: ((ApplicationLaunchHandler) -> ())?)
    
    func showLogin(configure: (_ module: LoginModule) -> ())
}
