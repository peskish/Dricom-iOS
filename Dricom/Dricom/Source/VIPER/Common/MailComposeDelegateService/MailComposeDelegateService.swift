import MessageUI

protocol MailComposeDelegateService: MFMailComposeViewControllerDelegate {
    var completion: ((_ result: MFMailComposeResult, _ error: NSError?) -> ())? { get set }
}

final class MailComposeDelegateServiceImpl: NSObject, MailComposeDelegateService  {
    // MARK: - MailComposeDelegateService
    var completion: ((_ result: MFMailComposeResult, _ error: NSError?) -> ())?
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Swift.Error?) {
        completion?(result, error as NSError?)
    }
}
