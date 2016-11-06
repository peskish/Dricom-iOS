import UIKit

protocol LoginAssembly: class {
    func module(
        configure: (_ module: LoginModule) -> ())
        -> UIViewController
}
