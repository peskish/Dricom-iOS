import UIKit

enum CameraResult {
    case finished(photo: UIImage)
    case cancelled
}

protocol CameraModule: class, ModuleFocusable, ModuleDismissable {
    var onFinish: ((CameraResult) -> ())? { get set }
}
