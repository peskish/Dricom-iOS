final class LicenseNormalizer {
    // хотим разрешить ввод в любой раскладке, upper и lower case, но преобразовывать все к единому виду
    static func normalize(license: String?) -> String? {
        guard let license = license else { return nil }
        
        var result = license
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
            .uppercased()
        
        for (key, value) in cyrillicToLatinSymbolsTable {
            result = result.replacingOccurrences(of: key, with: value)
        }
        
        return result
    }
    
    // А, В, Е, К, М, Н, О, Р, С, Т, У, Х - это разрешенные символы в российских номерных знаках
    private static let cyrillicToLatinSymbolsTable: [String: String] = [
        "\u{0410}": "\u{0041}", // A
        "\u{0412}": "\u{0042}", // B
        "\u{0415}": "\u{0045}", // E
        "\u{041a}": "\u{004b}", // K
        "\u{041c}": "\u{004d}", // M
        "\u{041d}": "\u{0048}", // H
        "\u{041e}": "\u{004f}", // O
        "\u{0420}": "\u{0050}", // P
        "\u{0421}": "\u{0043}", // C
        "\u{0422}": "\u{0054}", // T
        "\u{0423}": "\u{0059}", // Y
        "\u{0425}": "\u{0058}"  // X
    ]
}
