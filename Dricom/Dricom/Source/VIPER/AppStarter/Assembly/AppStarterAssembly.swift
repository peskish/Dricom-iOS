import UIKit

protocol AppStarterAssembly: class {
    func module(disposeBag: DisposeBag)
        -> (viewController: UIViewController, applicationLaunchHandler: ApplicationLaunchHandler)
}
