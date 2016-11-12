import UIKit

protocol RegisterAssembly: class {
    func module(
        configure: (_ module: RegisterModule) -> ())
        -> UIViewController
}
