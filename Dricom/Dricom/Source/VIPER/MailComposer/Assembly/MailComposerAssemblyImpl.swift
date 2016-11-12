import MessageUI

final class MailComposerAssemblyImpl: BaseAssembly, MailComposerAssembly {
    func tryCreatingMailComposeViewController(
        toRecipients: [String],
        subject: String,
        body: String,
        isHTML: Bool,
        moduleOutput: MFMailComposeViewControllerDelegate)
        -> UINavigationController?
    {
        guard MFMailComposeViewController.canSendMail()
            else { return nil }
        
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.setToRecipients(toRecipients)
        mailComposeViewController.setSubject(subject)
        mailComposeViewController.setMessageBody(body, isHTML: isHTML)
        mailComposeViewController.mailComposeDelegate = moduleOutput
        
        return mailComposeViewController
    }
}
