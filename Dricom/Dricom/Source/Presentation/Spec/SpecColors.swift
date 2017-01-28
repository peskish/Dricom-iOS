import UIKit

protocol ActionButtonColorScheme {
    static var title: UIColor { get }
    static var normalBackground: UIColor { get }
    static var highlightedBackground: UIColor { get }
    static var border: UIColor? { get }
}

struct SpecColors {
    static let textMain = UIColor.white
    
    struct Background {
        static let defaultEdge = UIColor(netHex: 0x007ECA)
        static let defaultCenter = UIColor(netHex: 0x02B4EA)
    }
    
    struct ActionButton {
        struct Light: ActionButtonColorScheme {
            static let title = UIColor.drcSlate
            static let normalBackground = UIColor.drcWhite
            static let highlightedBackground = UIColor.drcSilver
            static let border: UIColor? = UIColor.drcSilver
        }
        struct Dark: ActionButtonColorScheme {
            static let title = UIColor.drcWhite
            static let normalBackground = UIColor.drcBlue
            static let highlightedBackground = UIColor.drcWarmBlue
            static let border: UIColor? = nil
        }
    }
    
    struct InputField {
        static let textMain = SpecColors.textMain
        static let textInvalid = UIColor(netHex: 0xED6C8D)
        static let placeholder = UIColor(netHex: 0x65C3EE)
        static let stroke = UIColor(netHex: 0x65C3EE)
    }
}
