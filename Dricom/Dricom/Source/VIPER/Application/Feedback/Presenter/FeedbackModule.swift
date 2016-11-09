import Foundation

enum FeedbackResult {
    case finished
}

protocol FeedbackModule: class, ModuleFocusable, ModuleDismissable {
    var onFinish: ((FeedbackResult) -> ())? { get set }
}
