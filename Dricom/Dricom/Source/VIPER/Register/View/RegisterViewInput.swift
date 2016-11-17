import UIKit

protocol RegisterViewInput: class, ViewLifecycleObservable, MessageDisplayable {
    func setAddPhotoTitle(_ title: String)
    func setAddPhotoImage(_ image: UIImage?)
    var onAddPhotoButtonTap: (() -> ())? { get set }
}
