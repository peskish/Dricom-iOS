import Foundation

protocol RegisterViewInput: class, ViewLifecycleObservable, MessageDisplayable {
    func setAddPhotoTitle(_ title: String)
    var onAddPhotoButtonTap: (() -> ())? { get set }
}
