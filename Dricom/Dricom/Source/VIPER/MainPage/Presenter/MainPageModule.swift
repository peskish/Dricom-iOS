import Foundation

enum MainPageResult {
    case finished
    case cancelled
}

protocol MainPageModule: class, ModuleFocusable, ModuleDismissable {
    var onFinish: ((MainPageResult) -> ())? { get set }
}
