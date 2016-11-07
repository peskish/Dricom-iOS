//
// HOWTO: Display StandardAlert.
// 1. Open your ViewInput protocol
// 2. Add conformance to protocol AlertDisplayable
// 3. Open your presenter
// 4. Write showAlert(<your alert here>)
//
// To show action sheet create alert this way: StandardAlert(type: .actionSheet)
//
// Example:
//
// let alert = StandardAlert()
// let okButton = StandardAlert.Button("Do things")
// alert.title = "Hello, \(username)!"
// alert.message = "Welcome to my gorgeous app!"
// alert.cancelButton = StandardAlert.Button("Cancel")
// alert.buttons = [okButton]
//
// alert.completion = { [weak self] button in
//     if button === okButton {
//         self?.doThings()
//     )
// }

import UIKit

// NOTE: Often refers to UIViewController. Consider using weak var.
protocol AlertDisplayable: class {
    func showAlert(_: StandardAlert)
}

extension AlertDisplayable where Self: UIViewController {
    func showAlert(_ alert: StandardAlert) {
        StandardAlertDisplayer().showAlert(alert, inViewController: self)
    }
}

final class StandardAlertDisplayer {
    func showAlert(_ alert: StandardAlert, inViewController viewController: UIViewController) {
        WindowWaiter.tryWaitForWindowInController(viewController) { window in
            if window != nil {
                alert.showInViewController(viewController)
            } else {
                debugPrint("failed to get window to show alert \(alert)")
            }
        }
    }
}
