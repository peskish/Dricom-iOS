import UIKit

protocol CameraViewInput: class, ViewLifecycleObservable, MessageDisplayable {
    var onDidTakePhoto: ((UIImage) -> ())? { get set }
    var onDenyCameraPermission: (() -> ())? { get set }
    var onCloseButtonTap: (() -> ())? { get set }
}
