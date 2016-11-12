import Foundation

protocol FeedbackViewInput: class, ViewLifecycleObservable, MessageDisplayable {
    func setFeedbackButtonTitle(_ title: String)
    func setSupportButtonTitle(_ title: String)
    
    var onCloseButtonTap: (()->())? { get set }
    var onFeedbackButtonTap: (() -> ())? { get set }
    var onSupportButtonTap: (() -> ())? { get set }
    var onFbButtonTap: (() -> ())? { get set }
    var onVkButtonTap: (() -> ())? { get set }
    var onInstagramButtonTap: (() -> ())? { get set }
}
