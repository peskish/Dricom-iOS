import UIKit

protocol ChatListAssembly: class {
    func module() -> (viewController: UIViewController, interface: ChatListModule)
}
