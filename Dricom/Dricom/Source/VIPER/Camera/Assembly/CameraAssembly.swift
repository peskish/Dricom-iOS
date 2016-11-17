import UIKit

protocol CameraAssembly: class {
    func module(configure: (_ module: CameraModule) -> ()) -> UIViewController
}
