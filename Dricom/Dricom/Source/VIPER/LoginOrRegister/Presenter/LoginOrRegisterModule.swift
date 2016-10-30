import Foundation

enum LoginOrRegisterResult {
    case Login
    case Register
}

protocol LoginOrRegisterModule: class {
    var onFinish: ((LoginOrRegisterResult) -> ())? { get set }
}
