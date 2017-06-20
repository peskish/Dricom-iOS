import Foundation

enum ChatListResult {
    case Finished
    case Cancelled
}

protocol ChatListModule: class, ModuleFocusable, ModuleDismissable {
    var onFinish: ((ChatListResult) -> ())? { get set }
}
