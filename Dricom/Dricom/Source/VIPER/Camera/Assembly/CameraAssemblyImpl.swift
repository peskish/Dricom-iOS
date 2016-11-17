import UIKit

final class CameraAssemblyImpl: BaseAssembly, CameraAssembly {
    // MARK: - CameraAssembly
    func module(
        configure: (_ module: CameraModule) -> ())
        -> UIViewController
    {
        let interactor = CameraInteractorImpl()
        
        let viewController = CameraViewController()
        
        let router = CameraRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: viewController
        )
        
        let presenter = CameraPresenter(
            interactor: interactor,
            router: router
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        configure(presenter)
        
        return viewController
    }
}
