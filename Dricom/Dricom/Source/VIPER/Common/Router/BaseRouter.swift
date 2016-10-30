import UIKit

class BaseRouter {
    // MARK: - Properties
    let assemblyFactory: AssemblyFactory
    weak var viewController: UIViewController?
    var navigationController: UINavigationController? {
        return viewController?.navigationController
    }
    
    // MARK: - Init
    init(assemblyFactory: AssemblyFactory, viewController: UIViewController) {
        self.assemblyFactory = assemblyFactory
    }
}
