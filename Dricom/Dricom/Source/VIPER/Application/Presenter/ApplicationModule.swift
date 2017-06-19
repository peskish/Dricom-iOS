import Foundation

protocol ApplicationLaunchHandler {
    func handleApplicationDidFinishLaunching()
}

protocol ApplicationModule: class {
    func showLogin(shouldResetViewState: Bool)
}
