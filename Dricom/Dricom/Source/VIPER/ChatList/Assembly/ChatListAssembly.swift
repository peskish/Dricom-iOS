import UIKit

protocol ChatListAssembly: class {
    func module(
        configure: (_ module: ChatListModule) -> ())
        -> UIViewController
}
