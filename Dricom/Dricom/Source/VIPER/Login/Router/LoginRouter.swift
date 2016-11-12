import Foundation

protocol LoginRouter: class, RouterFocusable, RouterDismissable, RouterFeedbackShowable {
    func showRegister(configure: (_ module: RegisterModule) -> ())
}
