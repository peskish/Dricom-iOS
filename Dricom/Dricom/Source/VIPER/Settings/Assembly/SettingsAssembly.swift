import UIKit

protocol SettingsAssembly: class {
    func module() -> (viewController: UIViewController, interface: SettingsModule)
}
