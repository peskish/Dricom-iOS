import Foundation

public extension String {
    // From internet, seems to be viable. Swift 2.0 has such converter in standard library.
    // TODO: use standard constructor of UInt in Swift 2.0
    func toUInt() -> UInt? {
        if self.contains("-") {
            return nil
        }
        return withCString { cptr -> UInt? in
            var endPtr : UnsafeMutablePointer<Int8>? = nil
            errno = 0
            let result = strtoul(cptr, &endPtr, 10)
            if errno != 0 || endPtr?.pointee != 0 {
                return nil
            } else {
                return result
            }
        }
    }
    
    func toInt64() -> Int64? {
        let scanner = Scanner(string: self)
        var value: Int64 = 0
        if scanner.scanInt64(&value) {
            return value
        } else {
            return nil
        }
    }
    
    func toUInt64() -> UInt64? {
        let scanner = Scanner(string: self)
        var value: UInt64 = 0
        if scanner.scanUnsignedLongLong(&value) {
            return value
        } else {
            return nil
        }
    }
    
    var byCapitalizingFirstCharacter: String {
        if characters.count >= 1 {
            let secondCharacterIndex = characters.index(startIndex, offsetBy: 1)
            return substring(to: secondCharacterIndex).capitalized + substring(from: secondCharacterIndex)
        } else {
            return self
        }
    }
    
    func toUrl() -> URL? {
        return URL(string: self)
    }
    
    func toHttpUrl() -> URL? {
        return URL.httpURL(string: self)
    }
    
    func priceFormatted() -> String {
        let noSpacesString = replacingOccurrences(of: " ", with: "")
        var formattedString = ""
        var charNum = 0
        for character in noSpacesString.characters.reversed() {
            charNum += 1
            let separator = (charNum > 1 && charNum % 3 == 1) ? " " : ""
            formattedString = String(character) + separator + formattedString
        }
        return formattedString
    }
    
    func trim() -> String {
        return trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        )
    }
    
    // TODO: Revisit the algorithm
    // TODO: Rename, set pattern as a some kind of paramerer
    func stringByStrippingTags() -> String {
        var r: NSRange
        var s: NSString = self.copy() as! NSString
        let pattern = "&[a-zA-Z]+;"
        
        r = s.range(of: pattern, options: .regularExpression)
        while r.location != NSNotFound {
            s = s.replacingCharacters(in: r, with: "") as NSString
            r = s.range(of: pattern, options: .regularExpression)
        }
        return s as String
    }
    
    func rangesOfString(_ string: String) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        var sourceString = self
        
        while !sourceString.isEmpty {
            if let range = sourceString.range(of: string) {
                sourceString = sourceString.substring(from: range.upperBound)
                ranges.append(range)
            } else {
                break
            }
        }
        
        return ranges
    }
    
    // Useful methods for creating CustomDebugStringConvertible
    
    private static let indentation = "    "
    private static let newLine = "\n"
    
    func indent(_ indentation: String = indentation) -> String {
        return self
            .components(separatedBy: String.newLine)
            .map { indentation + $0 }
            .joined(separator: String.newLine)
    }
    
    func wrapAndIndent(prefix: String = "", postfix: String = "", skipIfEmpty: Bool = true) -> String {
        if isEmpty && skipIfEmpty {
            return ""
        } else {
            return prefix + String.newLine
                + indent() + String.newLine
                + postfix
        }
    }
    
    func urlEncodedString() -> String? {
        let charactersToBeEscaped = ":/?&=;+!@#$()~',*[] "
        let charactersToLeaveUnescaped = "."
        
        let result = CFURLCreateStringByAddingPercentEscapes(
            kCFAllocatorDefault,
            self as CFString!,
            charactersToLeaveUnescaped as CFString!,
            charactersToBeEscaped as CFString!,
            CFStringBuiltInEncodings.UTF8.rawValue
        )
        
        if let result = result {
            return String(result).replacingOccurrences(of: "%20", with: "+")
        } else {
            return nil
        }
    }
    
    func urlDecodedString() -> String {
        return replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? ""
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailTestPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTestPredicate.evaluate(with: self)
    }

    func withoutNewLines() -> String {
        return replacingOccurrences(of: "\n", with: "")
    }
    
    func trimmed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
