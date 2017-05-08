import UIKit

protocol ChatAssembly: class {
    func module(position: ViewControllerPosition) -> UIViewController
}
