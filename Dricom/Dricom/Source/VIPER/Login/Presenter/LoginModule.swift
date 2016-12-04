import Foundation

enum LoginResult {
    case finished(user: User)
}

protocol LoginModule: class, ModuleFocusable, ModuleDismissable, ViewControllerPositionHolder {
    var onFinish: ((LoginResult) -> ())? { get set }
}
