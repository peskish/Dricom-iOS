import UIKit

protocol ApplicationAssembly: class {
    func module() -> (rootViewController: UIViewController?, applicationEventsHandler: ApplicationEventsHandler?)
}
