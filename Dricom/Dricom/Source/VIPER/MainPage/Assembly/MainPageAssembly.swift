import UIKit

protocol MainPageAssembly: class {
    func module() -> (viewController: UIViewController, interface: MainPageModule)
}
