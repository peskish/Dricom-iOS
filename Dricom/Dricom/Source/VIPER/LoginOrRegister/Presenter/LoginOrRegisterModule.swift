import Foundation

enum LoginOrRegisterResult {
    case login
    case register
}

protocol LoginOrRegisterModule: class {
    var onFinish: ((LoginOrRegisterResult) -> ())? { get set }
}
