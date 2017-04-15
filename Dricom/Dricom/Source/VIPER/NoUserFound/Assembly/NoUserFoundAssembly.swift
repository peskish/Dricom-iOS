import UIKit

protocol NoUserFoundAssembly: class {
    func module(
        configure: (_ module: NoUserFoundModule) -> ())
        -> UIViewController
}
