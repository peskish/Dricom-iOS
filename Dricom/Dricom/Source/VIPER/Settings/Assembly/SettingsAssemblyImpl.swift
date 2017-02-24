import UIKit

final class SettingsAssemblyImpl: BaseAssembly, SettingsAssembly {
    // MARK: - SettingsAssembly
    func module() -> (viewController: UIViewController, interface: SettingsModule)
    {
        let interactor = SettingsInteractorImpl()
        
        let viewController = SettingsViewController()
        
        let router = SettingsRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: viewController
        )
        
        let presenter = SettingsPresenter(
            interactor: interactor,
            router: router
        )
        
        viewController.addDisposable(presenter)
        
        presenter.view = viewController
        
        return (viewController: viewController, interface: presenter)
    }
}
