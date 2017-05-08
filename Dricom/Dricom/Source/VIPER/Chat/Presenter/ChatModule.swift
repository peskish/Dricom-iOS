import Foundation

enum ChatResult {
    case Finished
    case Cancelled
}

protocol ChatModule: class, ModuleFocusable, ModuleDismissable {
    var onFinish: ((ChatResult) -> ())? { get set }
}
