import MessageUI

protocol MailComposerAssembly: class {
    func tryCreatingMailComposeViewController(
        toRecipients: [String],
        subject: String,
        body: String,
        isHTML: Bool,
        moduleOutput: MFMailComposeViewControllerDelegate)
        -> UINavigationController? // depends on `canSendMail()`
}
