import UIKit

protocol PhoneService: class {
    func call(number: String)
}

final class PhoneServiceImpl: PhoneService {
    func call(number: String) {
        if let urlForPhoneApp = URL(string: numberForTelScheme(number: number)) {
            UIApplication.shared.openURL(urlForPhoneApp)
        }
    }
    
    private func numberForTelScheme(number: String) -> String {
        // https://developer.apple.com/library/content/featuredarticles/iPhoneURLScheme_Reference/PhoneLinks/PhoneLinks.html
        // To prevent users from maliciously redirecting phone calls or changing the behavior of
        // a phone or account, the Phone app supports most, but not all, of the special characters
        // in the tel scheme. Specifically, if a URL contains the * or # characters, the Phone app
        // does not attempt to dial the corresponding phone number. If your app receives URL strings
        // from the user or an unknown source, you should also make sure that any special characters
        // that might not be appropriate in a URL are escaped properly. For native apps, use the
        // stringByAddingPercentEscapesUsingEncoding: method of NSString to escape characters, which
        // returns a properly escaped version of your original string.
        
        // from the comment above: "contains the * or # characters"
        let numberWithoutIllegalChars = number
            .replacingOccurrences(of: "*", with: "")
            .replacingOccurrences(of: "#", with: "")
        
        // from the comment above: "stringByAddingPercentEscapesUsingEncoding: method of NSString"
        let escapedNumber = (numberWithoutIllegalChars as NSString)
            .addingPercentEscapes(using: String.Encoding.utf8.rawValue) ?? number
        
        return "tel:\(escapedNumber)"
    }
}
