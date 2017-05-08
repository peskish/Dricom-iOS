import UIKit

protocol ChatAssembly: class {
    func module(
        configure: (_ module: ChatModule) -> ())
        -> UIViewController
}
