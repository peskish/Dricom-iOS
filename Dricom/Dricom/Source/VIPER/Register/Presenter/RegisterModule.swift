import Foundation

enum RegisterResult {
    case finished
}

protocol RegisterModule: class, ModuleFocusable, ModuleDismissable {
    var onFinish: ((RegisterResult) -> ())? { get set }
}
