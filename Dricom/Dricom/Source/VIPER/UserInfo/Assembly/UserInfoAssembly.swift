import UIKit

protocol UserInfoAssembly: class {
    func module(
        userInfo: UserInfo,
        configure: (_ module: UserInfoModule) -> ())
        -> UIViewController
}
