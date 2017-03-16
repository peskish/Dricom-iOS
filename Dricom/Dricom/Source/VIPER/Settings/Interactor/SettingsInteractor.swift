import Foundation

protocol SettingsInteractor: class {
    func logOut(completion: (() -> ())?)
    var onUserDataReceived: ((User) -> ())? { get set }
}
