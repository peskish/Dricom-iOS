// A VERY good way to pluralize strings:
// https://developer.mozilla.org/en-US/docs/Mozilla/Localization/Localization_and_Plurals
public enum PluralRule {
    case russian // (Belarusian, Bosnian, Croatian, Serbian, Russian, Ukrainian)
}

public extension String {
    // A very tiny and dumb function to do pluralization. We don't need more complex stuff at the moment.
    // If we need more: create an instance function and use localization:
    // E.g.: "%@ bytes".pluralize(42) or something like that
    static func pluralize(_ number: Int, forms: [String], pluralRule: PluralRule = .russian) -> String? {
        let pluralForm = pluralFormFromNumber(number, pluralRule: pluralRule)
        return forms.elementAtIndex(pluralForm)
    }
    
    private static func pluralFormFromNumber(_ number: Int, pluralRule: PluralRule) -> Int {
        switch pluralRule {
        case .russian:
            return russianPluralFormFromNumber(number)
        }
    }
    
    private static func russianPluralFormFromNumber(_ number: Int) -> Int {
        let remaining10 = number % 10
        
        if (remaining10 == 1) && (number != 11) {
            // form #0: ends in 1, excluding 11
            // E.g.: "1 кот"
            return 0
        }
        else if (remaining10 >= 2 && remaining10 <= 4) && !(number >= 12 && number <= 14) {
            // form #1: ends in 2-4, excluding 12-14
            // E.g.: "2 кота"
            return 1
        }
        else {
            // form #2: everything else
            // E.g.: "5 котов"
            return 2
        }
    }
}
