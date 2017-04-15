import UIKit

protocol UserInfoAssembly: class {
    func module(
        user: User,
        configure: (_ module: UserInfoModule) -> ())
        -> UIViewController
}
