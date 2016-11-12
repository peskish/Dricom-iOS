import UIKit

final class FeedbackInteractorImpl: FeedbackInteractor {
    private let application = UIApplication.shared
    
    private let vkUrl = "vk://vk.com/dricomru"
    private let fbUrl = "fb://profile/dricom.ru"
    private let instagramUrl = "instagram://user?username=dricomru"
    
    private let vkHttpUrl = "https://vk.com/dricomru"
    private let fbHttpUrl = "https://www.facebook.com/dricom.ru"
    private let instagramHttpUrl = "https://www.instagram.com/dricomru/"
    
    // MARK: - FeedbackInteractor
    func openInstagram() {
        guard let url = URL(string: instagramUrl), let httpUrl = URL(string: instagramHttpUrl)
            else { return }
        
        openUrl(url, fallbackUrl: httpUrl)
    }
    
    func openVk() {
        guard let url = URL(string: vkUrl), let httpUrl = URL(string: vkHttpUrl)
            else { return }
        
        openUrl(url, fallbackUrl: httpUrl)
    }
    
    func openFb() {
        guard let url = URL(string: fbUrl), let httpUrl = URL(string: fbHttpUrl)
            else { return }
        
        openUrl(url, fallbackUrl: httpUrl)
    }
    
    // MARK: - Private
    private func openUrl(_ url: URL, fallbackUrl: URL) {
        if application.canOpenURL(url) {
            application.openURL(url)
        } else {
            application.openURL(fallbackUrl)
        }
    }
}
