import UIKit

protocol ChatAssembly: class {
    func module(channel: Channel, position: ViewControllerPosition) -> UIViewController
}
