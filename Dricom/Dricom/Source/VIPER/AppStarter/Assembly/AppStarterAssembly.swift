import UIKit

protocol AppStarterAssembly: class {
    func module() -> (rootViewController: UIViewController?, starterModule: AppStarterModule?)
}
