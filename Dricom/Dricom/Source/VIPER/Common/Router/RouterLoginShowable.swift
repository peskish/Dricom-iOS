import UIKit

protocol RouterLoginShowable: class {
    func showLogin(
        configure: (_ module: LoginModule) -> (),
        animated: Bool,
        modalTransitionStyle: UIModalTransitionStyle?,
        modalPresentationStyle: UIModalPresentationStyle?
    )
}

extension RouterLoginShowable where Self: BaseRouter {
    func showLogin(
        configure: (_ module: LoginModule) -> (),
        animated: Bool,
        modalTransitionStyle: UIModalTransitionStyle?,
        modalPresentationStyle: UIModalPresentationStyle?)
    {
        guard let viewController = viewController else {
            assertionFailure("viewController is nil")
            return
        }
        
        let assembly = assemblyFactory.loginAssembly()
        let targetViewController = assembly.module(configure: configure)
        let navigationController = UINavigationController(rootViewController: targetViewController)
        
        if let modalTransitionStyle = modalTransitionStyle {
            navigationController.modalTransitionStyle = modalTransitionStyle
        }
        
        if let modalPresentationStyle = modalPresentationStyle {
            navigationController.modalPresentationStyle = modalPresentationStyle
        }
        
        viewController.present(navigationController, animated: animated, completion: nil)
    }
}

