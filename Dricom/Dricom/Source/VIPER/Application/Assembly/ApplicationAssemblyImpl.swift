import UIKit

final class ApplicationAssemblyImpl: BaseAssembly, ApplicationAssembly {
    // MARK: - ApplicationAssembly
    func module() -> UITabBarController {
        // TODO: Setup tabs
        return UITabBarController()
    }
}
