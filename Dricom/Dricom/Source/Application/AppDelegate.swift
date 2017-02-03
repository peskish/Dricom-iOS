import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties with app lifetime
    var window: UIWindow?
    let serviceFactory = ViewDebugServiceFactory()
    lazy var assemblyFactory: AssemblyFactory = {
        return AssemblyFactoryImpl(serviceFactory: self.serviceFactory)
    }()

    // MARK: - UIApplicationDelegate
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        let applicationAssembly = assemblyFactory.applicationAssembly()
        let applicationModule = applicationAssembly.module()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = applicationModule.rootViewController
        window?.makeKeyAndVisible()
        
        applicationModule.applicationLaunchHandler.handleApplicationDidFinishLaunching()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

