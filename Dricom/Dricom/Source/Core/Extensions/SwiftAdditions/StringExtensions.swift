import Foundation

public extension String {
    
    var urlEncoded: String? {
        let charactersToBeEscaped = ":/?&=;+!@#$()~',*[] "
        
        let toBeEscapedSet = CharacterSet(charactersIn: charactersToBeEscaped).inverted
        let escapedString = addingPercentEncoding(withAllowedCharacters: toBeEscapedSet)
        
        return escapedString?.replacingOccurrences(of: "%20", with: "+")
    }
    
    func trimmed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
