import UIKit

final class ApplicationAssemblyImpl: BaseAssembly, ApplicationAssembly {
    private static weak var applicationModuleInstance: ApplicationModule?
    
    // MARK: - ApplicationAssembly
    func applicationModule() -> ApplicationModule? {
        return ApplicationAssemblyImpl.applicationModuleInstance
    }
    
    // This function should be called once during the application launch
    func module() -> (rootViewController: UIViewController, applicationLaunchHandler: ApplicationLaunchHandler) {
        let tabBarController = ApplicationTabBarController()
        
        let interactor = ApplicationInteractorImpl()
        
        let router = ApplicationRouterImpl(
            assemblyFactory: assemblyFactory,
            viewController: tabBarController
        )
        
        let presenter = ApplicationPresenter(
            interactor: interactor,
            router: router
        )
        
        ApplicationAssemblyImpl.applicationModuleInstance = presenter
        
        let mainPageModule = assembleMainPageModule()
        let chatListModule = assembleChatListModule()
        let settingsModule = assembleSettingsModule()
        
        let viewControllers = [
            mainPageModule.viewController,
            chatListModule.viewController,
            settingsModule.viewController
        ]
        tabBarController.viewControllers = viewControllers
        
        tabBarController.addDisposable(presenter)
        
        presenter.view = tabBarController
        presenter.mainPageModule = mainPageModule.interface
        presenter.chatListModule = chatListModule.interface
        presenter.settingsModule = settingsModule.interface
        
        return (rootViewController: tabBarController, applicationLaunchHandler: presenter)
    }
    
    // MARK: - Private
    private func assembleMainPageModule() -> (viewController: UIViewController, interface: MainPageModule) {
        let assembly = assemblyFactory.mainPageAssembly()
        let module = assembly.module()
        let navigationController = UINavigationController(rootViewController: module.viewController)
        navigationController.tabBarItem = UITabBarItem(
            title: "Мой Dricom",
            image: #imageLiteral(resourceName: "TabMain"),
            selectedImage: #imageLiteral(resourceName: "TabMainSelected")
        )
        navigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        return (viewController: navigationController, interface: module.interface)
    }
    
    private func assembleChatListModule() -> (viewController: UIViewController, interface: ChatListModule) {
        let assembly = assemblyFactory.chatListAssembly()
        let module = assembly.module()
        let navigationController = UINavigationController(rootViewController: module.viewController)
        navigationController.tabBarItem = UITabBarItem(
            title: "Сообщения",
            image: #imageLiteral(resourceName: "TabChat"),
            selectedImage: #imageLiteral(resourceName: "TabChatSelected")
        )
        navigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        return (viewController: navigationController, interface: module.interface)
    }
    
    private func assembleSettingsModule() -> (viewController: UIViewController, interface: SettingsModule) {
        let assembly = assemblyFactory.settingsAssembly()
        let module = assembly.module()
        let navigationController = UINavigationController(rootViewController: module.viewController)
        navigationController.tabBarItem = UITabBarItem(
            title: "Настройки",
            image: #imageLiteral(resourceName: "TabSettings"),
            selectedImage: #imageLiteral(resourceName: "TabSettingsSelected")
        )
        navigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        return (viewController: navigationController, interface: module.interface)
    }
}
