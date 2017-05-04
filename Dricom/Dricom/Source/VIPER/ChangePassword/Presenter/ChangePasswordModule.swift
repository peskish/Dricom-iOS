import Foundation

enum ChangePasswordResult {
    case Finished
    case Cancelled
}

protocol ChangePasswordModule: class, ModuleFocusable, ModuleDismissable {
    var onFinish: ((ChangePasswordResult) -> ())? { get set }
}
