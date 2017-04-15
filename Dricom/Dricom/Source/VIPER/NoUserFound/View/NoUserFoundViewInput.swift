import Foundation

protocol NoUserFoundViewInput: class, ViewLifecycleObservable, MessageDisplayable {
    func setMessage(_ message: String)
    func setDescription(_ description: String)
    var onCloseTap: (() -> ())? { get set }
}
