import UIKit

protocol AppStarterAssembly: class {
    func module(disposeBag: DisposeBag, mainPageModule: MainPageModule?)
        -> (viewController: UIViewController, applicationLaunchHandler: ApplicationLaunchHandler)
}
