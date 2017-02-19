protocol ApplicationRouter: class {
    func showAppStarter(
        disposeBag: DisposeBag,
        mainPageModule: MainPageModule?,
        completion: ((ApplicationLaunchHandler) -> ())?)
}
