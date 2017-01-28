import UIKit

protocol RouterCameraShowable: class {
    func showCamera(configure: (_ module: CameraModule) -> ())
}

extension RouterCameraShowable where Self: BaseRouter {
    func showCamera(configure: (_ module: CameraModule) -> ()) {
        let assembly = assemblyFactory.cameraAssembly()
        let targetViewController = assembly.module(configure: configure)
        let navigationController = UINavigationController(rootViewController: targetViewController)
        viewController?.present(navigationController, animated: true, completion: nil)
    }
}
