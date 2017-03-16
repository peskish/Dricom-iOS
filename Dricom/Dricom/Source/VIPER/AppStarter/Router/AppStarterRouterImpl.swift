import UIKit

final class AppStarterRouterImpl: BaseRouter, AppStarterRouter, RouterLoginShowable {
    // MARK: - AppStarterRouter
    func showLogin(configure: (_ module: LoginModule) -> ()) {
        showLogin(
            configure: configure,
            animated: true,
            modalTransitionStyle: .crossDissolve,
            modalPresentationStyle: .overCurrentContext
        )
    }
}
