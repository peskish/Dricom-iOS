import Foundation

protocol FeedbackViewInput: class, ViewLifecycleObservable, MessageDisplayable {
    var onCloseButtonTap: (()->())? { get set }
}
