import Foundation

enum NoUserFoundResult {
    case Finished
    case Cancelled
}

protocol NoUserFoundModule: class, ModuleFocusable, ModuleDismissable {
    var onFinish: ((NoUserFoundResult) -> ())? { get set }
}
