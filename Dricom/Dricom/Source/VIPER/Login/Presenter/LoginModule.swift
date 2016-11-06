import Foundation

enum LoginResult {
    case Finished
    case Cancelled
}

protocol LoginModule: class, ModuleFocusable, ModuleDismissable {
    var onFinish: ((LoginResult) -> ())? { get set }
}
