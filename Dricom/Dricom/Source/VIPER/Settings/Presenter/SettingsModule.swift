import Foundation

enum SettingsResult {
    case Finished
    case Cancelled
}

protocol SettingsModule: class, ModuleFocusable, ModuleDismissable {
    var onFinish: ((SettingsResult) -> ())? { get set }
}
