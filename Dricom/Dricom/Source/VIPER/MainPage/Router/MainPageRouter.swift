import Foundation

protocol MainPageRouter: class, RouterFocusable, RouterDismissable {
    func showUserInfo(_ userInfo: UserInfo, configure: (_ module: UserInfoModule) -> ())
    func showNoUserFound()
}
