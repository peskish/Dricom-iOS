import UIKit

final class FeedbackRouterImpl: BaseRouter, FeedbackRouter {
    // MARK: - Dependencies
    private let mailComposeDelegateService: MailComposeDelegateService
    
    // MARK: - Init
    init(
        assemblyFactory: AssemblyFactory,
        viewController: UIViewController,
        mailComposeDelegateService: MailComposeDelegateService
        )
    {
        self.mailComposeDelegateService = mailComposeDelegateService
        super.init(assemblyFactory: assemblyFactory, viewController: viewController)
    }
    
    // MARK: - FeedbackRouter
    func showMailComposer(
        toRecepients: [String],
        subject: String,
        body: String,
        isHTML: Bool)
    {
        let mailComposerAssembly = assemblyFactory.mailComposerAssembly()
        
        guard let mailComposeViewController = mailComposerAssembly.tryCreatingMailComposeViewController(
            toRecipients: toRecepients,
            subject: subject,
            body: body,
            isHTML: isHTML,
            moduleOutput: mailComposeDelegateService
            )
            else { return }
        
        viewController?.present(mailComposeViewController, animated: true) { [weak self] in
            self?.mailComposeDelegateService.completion = { _ in
                mailComposeViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
}
