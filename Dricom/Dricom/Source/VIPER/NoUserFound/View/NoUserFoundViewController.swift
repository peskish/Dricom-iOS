import UIKit

final class NoUserFoundViewController: BaseViewController, NoUserFoundViewInput {
    private let noUserFoundView = NoUserFoundView()
    
    override func loadView() {
        view = noUserFoundView
    }
    
    // MARK: - NoUserFoundViewInput
    func setMessage(_ message: String) {
        noUserFoundView.setMessage(message)
    }
    
    func setDescription(_ description: String) {
        noUserFoundView.setDescription(description)
    }
    
    var onCloseTap: (() -> ())? {
        get { return noUserFoundView.onCloseTap }
        set { noUserFoundView.onCloseTap = newValue }
    }
}
