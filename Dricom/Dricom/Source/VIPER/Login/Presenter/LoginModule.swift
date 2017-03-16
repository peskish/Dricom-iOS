import Foundation

enum LoginResult {
    case finished
}

protocol LoginModule: class, ModuleFocusable, ModuleDismissable, ViewControllerPositionHolder {
    var onFinish: ((LoginResult) -> ())? { get set }
}
