import UIKit

protocol AppStarterAssembly: class {
    func module(disposeBag: DisposeBag, userSettable: UserSettable?)
        -> (viewController: UIViewController, applicationLaunchHandler: ApplicationLaunchHandler)
}
