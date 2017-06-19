import UIKit

final class ApplicationTabBarController: UITabBarController, ApplicationViewInput, DisposeBag, DisposeBagHolder {
    // MARK: - ApplicationViewInput
    func selectTab(_ tab: ApplicationTab) {
        if let viewController = viewControllers?.elementAtIndex(tab.rawValue) {
            selectedViewController = viewController
        }
    }
    
    // MARK: - DisposeBagHolder
    let disposeBag: DisposeBag = DisposeBagImpl()
}
