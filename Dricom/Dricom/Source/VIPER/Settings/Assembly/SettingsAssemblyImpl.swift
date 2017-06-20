import UIKit

final class SettingsAssemblyImpl: BaseAssembly, SettingsAssembly {
    // MARK: - SettingsAssembly
    func module() -> (viewController: UIViewController, interface: SettingsModule)
    {
        let interactor = SettingsInteractorImpl(
            logoutService: serviceFactory.logoutService(),
            userDataObservable: serviceFactory.userDataObservable()
        )
        
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
        presenter.applicationModule = assemblyFactory.applicationAssembly().applicationModule()
        
        return (viewController: viewController, interface: presenter)
    }
}
