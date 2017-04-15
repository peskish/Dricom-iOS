import Foundation

enum UserInfoResult {
    case Finished
    case Cancelled
}

protocol UserInfoModule: class, ModuleFocusable, ModuleDismissable {
    var onFinish: ((UserInfoResult) -> ())? { get set }
}
