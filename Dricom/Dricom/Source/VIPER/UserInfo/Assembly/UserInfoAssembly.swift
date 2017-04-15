import UIKit

protocol UserInfoAssembly: class {
    func module(
        configure: (_ module: UserInfoModule) -> ())
        -> UIViewController
}
