import Foundation

protocol MainPageInteractor: class {
    var onUserDataReceived: ((User) -> ())? { get set }
}
