import Foundation

enum RegisterResult {
    case finished(user: User)
}

protocol RegisterModule: class, ModuleFocusable, ModuleDismissable {
    var onFinish: ((RegisterResult) -> ())? { get set }
}
