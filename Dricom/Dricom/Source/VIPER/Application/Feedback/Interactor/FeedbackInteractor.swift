import Foundation

protocol FeedbackInteractor: class {
    func openInstagram()
    func openVk()
    func openFb()
    func canSendEmail() -> Bool
    func adminEmail() -> String
    func supportMessageData() -> SupportMessageData
}
