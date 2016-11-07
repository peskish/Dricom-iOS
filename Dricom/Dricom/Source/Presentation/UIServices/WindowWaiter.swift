import UIKit

final class WindowWaiter {
    static func tryWaitForWindowInController(_ viewController: UIViewController, completion: @escaping ((_ window: UIWindow?) -> ())) {
        tryWaitForWindow(
            windowGetter: { return viewController.view.window },
            completion: completion
        )
    }
    
    static func tryWaitForWindow(windowGetter: @escaping () -> UIWindow?,
        completion: @escaping ((_ window: UIWindow?) -> ()))
    {
        let numberOfAttempts = 1000
        
        tryWaitForWindow(
            windowGetter: windowGetter,
            initialNumberOfAttempts: numberOfAttempts,
            numberOfAttemptsLeft: numberOfAttempts,
            completion: completion
        )
    }
    
    private static func tryWaitForWindow(windowGetter: @escaping () -> UIWindow?,
        initialNumberOfAttempts: Int,
        numberOfAttemptsLeft: Int,
        completion: @escaping ((_ window: UIWindow?) -> ()))
    {
        if let window = windowGetter() {
            completion(window)
        } else if numberOfAttemptsLeft > 0 {
            // AI-2563: UIKit sometimes lags and does not return a window.
            // It usually happens after pop transitions or reverse modal transitions.
            // Have to add a delay to satisfy the animation quality.
            // Note: This spinlock does not block the UI, so it will not crash the app.
            OperationQueue.main.addOperation {
                self.tryWaitForWindow(
                    windowGetter: windowGetter,
                    initialNumberOfAttempts: initialNumberOfAttempts,
                    numberOfAttemptsLeft: numberOfAttemptsLeft - 1,
                    completion: completion
                )
            }
        } else {
            debugPrint("Failed to get window after \(initialNumberOfAttempts) attempts")
            completion(nil)
        }
    }
}
