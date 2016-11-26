import UIKit

protocol MainPageAssembly: class {
    func module(
        configure: (_ module: MainPageModule) -> ())
        -> UIViewController
}
