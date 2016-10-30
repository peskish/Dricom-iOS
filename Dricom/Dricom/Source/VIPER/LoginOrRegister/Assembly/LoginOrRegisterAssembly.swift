import UIKit

protocol LoginOrRegisterAssembly: class {
    func module(
        configure: (_ module: LoginOrRegisterModule) -> ())
        -> UIViewController
}
