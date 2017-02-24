protocol ApplicationRouter: class {
    func showAppStarter(
        disposeBag: DisposeBag,
        userSettable: UserSettable,
        completion: ((ApplicationLaunchHandler) -> ())?)
}
