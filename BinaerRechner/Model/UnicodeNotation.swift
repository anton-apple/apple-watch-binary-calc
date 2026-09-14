import Foundation

/// Hoch- und tiefgestellte Ziffern für die mathematische Schreibweise,
/// z. B. „2⁴“ oder „15₁₀“.
enum UnicodeNotation {
    private static let superscriptDigits: [Character] = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]
    private static let subscriptDigits: [Character] = ["₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉"]

    static func superscriptText(_ number: Int) -> String {
        convert(number, using: superscriptDigits)
    }

    static func subscriptText(_ number: Int) -> String {
        convert(number, using: subscriptDigits)
    }

    private static func convert(_ number: Int, using table: [Character]) -> String {
        var result = ""
        for character in String(max(number, 0)) {
            guard let digit = character.wholeNumberValue, table.indices.contains(digit) else { continue }
            result.append(table[digit])
        }
        return result
    }
}
