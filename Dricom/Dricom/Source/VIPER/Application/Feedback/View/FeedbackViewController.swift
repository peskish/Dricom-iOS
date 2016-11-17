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
    
    func setFeedbackButtonTitle(_ title: String) {
        feedbackView.setFeedbackButtonTitle(title)
    }
    
    func setSupportButtonTitle(_ title: String) {
        feedbackView.setSupportButtonTitle(title)
    }
    
    var onFeedbackButtonTap: (() -> ())? {
        get { return feedbackView.onFeedbackButtonTap }
        set { feedbackView.onFeedbackButtonTap = newValue }
    }
    
    var onSupportButtonTap: (() -> ())? {
        get { return feedbackView.onSupportButtonTap }
        set { feedbackView.onSupportButtonTap = newValue }
    }
    
    var onFbButtonTap: (() -> ())? {
        get { return feedbackView.onFbButtonTap }
        set { feedbackView.onFbButtonTap = newValue }
    }
    
    var onVkButtonTap: (() -> ())? {
        get { return feedbackView.onVkButtonTap }
        set { feedbackView.onVkButtonTap = newValue }
    }
    
    var onInstagramButtonTap: (() -> ())? {
        get { return feedbackView.onInstagramButtonTap }
        set { feedbackView.onInstagramButtonTap = newValue }
    }
}
