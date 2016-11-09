import UIKit

final class FeedbackViewController: BaseViewController, FeedbackViewInput {
    private let feedbackView = FeedbackView()
    
    override func loadView() {
        super.loadView()
        
        view = feedbackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Close"),
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
        
    }
    
    // MARK: - FeedbackViewInput
    var onCloseButtonTap: (()->())?
    @objc private func closeButtonTapped() {
        onCloseButtonTap?()
    }
}
