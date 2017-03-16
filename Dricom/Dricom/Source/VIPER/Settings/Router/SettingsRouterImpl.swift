import UIKit

final class SettingsRouterImpl: BaseRouter, SettingsRouter, RouterLoginShowable {
    // MARK: - SettingsRouter
    func showLogin(configure: (_ module: LoginModule) -> ()) {
        showLogin(
            configure: configure,
            animated: true,
            modalTransitionStyle: nil,
            modalPresentationStyle: nil
        )
    }
}
