import UIKit

protocol ChangePasswordAssembly: class {
    func module(
        configure: (_ module: ChangePasswordModule) -> ())
        -> UIViewController
}
