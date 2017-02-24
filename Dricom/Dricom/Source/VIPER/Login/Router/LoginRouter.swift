import Foundation

protocol LoginRouter: class, RouterFocusable, RouterDismissable {
    func showRegister(configure: (_ module: RegisterModule) -> ())
}
