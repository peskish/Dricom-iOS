import Foundation

protocol FeedbackRouter: class, RouterFocusable, RouterDismissable {
    func showMailComposer(
        toRecepients: [String],
        subject: String,
        body: String,
        isHTML: Bool)
}
