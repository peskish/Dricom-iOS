protocol ApplicationRouter: class {
    func showAppStarter(disposeBag: DisposeBag, completion: ((ApplicationLaunchHandler) -> ())?)
}
