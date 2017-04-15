import UIKit

final class MainPageRouterImpl: BaseRouter, MainPageRouter {
    // MARK: - MainPageRouter
    func showUser(_ user: User) {
        // TODO: 
    }
    
    func showNoUserFound() {
        let assembly = assemblyFactory.noUserFoundAssembly()
        let targetViewController = assembly.module()
        targetViewController.modalTransitionStyle = .crossDissolve
        viewController?.present(targetViewController, animated: true, completion: nil)
    }
}
