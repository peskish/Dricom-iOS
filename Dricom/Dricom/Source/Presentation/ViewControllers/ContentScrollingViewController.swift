import UIKit

class ContentScrollingViewController: BaseViewController {
    private var isVisible = false
    
    // MARK: - Init
    @nonobjc override init(position: ViewControllerPosition) {
        super.init(position: position)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onKeyboardWillChangeFrame(notification:)),
            name: .UIKeyboardWillChangeFrame,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - View events
    override func viewDidAppear(_ animated: Bool) {
        isVisible = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isVisible = false
    }
    
    // MARK: - Keyboard events
    @objc func onKeyboardWillChangeFrame(notification: Notification) {
        guard let contentScrollingView = view as? ContentScrollingView else {
            assertionFailure("Use with ContentScrollingView")
            return
        }
        
        guard isVisible else { return }
        
        contentScrollingView.onKeyboardWillChangeFrame(notification: notification)
    }
}
