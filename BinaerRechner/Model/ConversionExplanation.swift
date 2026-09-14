import Foundation

/// Der Rechenweg zu einem Wert – aufgebaut wie die Erklärung der Vorlage:
/// zuerst eine Übersicht aller Schreibweisen, danach je Zahlensystem die
/// Summe der Stellenwerte.
struct ConversionExplanation {
    /// Ab dieser Anzahl Summanden wird die Mitte durch „…“ ersetzt,
    /// damit die Zeile auf der Uhr lesbar bleibt.
    private static let maximumTerms = 12

    struct Step: Identifiable {
        let base: NumberBase
        /// Überschrift, z. B. „Binär (4 Bit)“.
        let title: String
        /// Rechenweg, z. B. „17₈ = 1·8¹ + 7·8⁰ = 15₁₀“.
        let text: String

        var id: Int { base.rawValue }
    }

    let value: UInt64
    /// z. B. „F₁₆ = 15₁₀ = 17₈ = 1111₂“.
    let overview: String
    let steps: [Step]

    init(value: UInt64) {
        self.value = value
        self.overview = Self.makeOverview(for: value)
        self.steps = NumberBase.explanationOrder.map { base in
            Step(base: base, title: Self.makeTitle(for: base, value: value), text: Self.expansion(of: value, in: base))
        }
    }

    /// „F₁₆ = 15₁₀ = 17₈ = 1111₂“
    private static func makeOverview(for value: UInt64) -> String {
        [NumberBase.hexadecimal, .decimal, .octal, .binary]
            .map { notation(of: value, in: $0) }
            .joined(separator: " = ")
    }

    private static func makeTitle(for base: NumberBase, value: UInt64) -> String {
        guard base == .binary else { return base.name }
        let bits = NumberParser.digitCount(value, base: .binary)
        return "\(base.name) (\(bits) Bit)"
    }

    /// „1111₂“
    static func notation(of value: UInt64, in base: NumberBase) -> String {
        NumberParser.format(value, base: base) + base.subscriptLabel
    }

    /// Der ausgeschriebene Stellenwert-Term, z. B.
    /// „F₁₆ = F·16⁰ = 15₁₀·16⁰ = 15₁₀“ oder „1111₂ = 1·2³ + 1·2² + 1·2¹ + 1·2⁰ = 15₁₀“.
    static func expansion(of value: UInt64, in base: NumberBase) -> String {
        let digits = Array(NumberParser.format(value, base: base))
        let highestExponent = digits.count - 1

        var symbolicTerms: [String] = []
        var numericTerms: [String] = []
        var hasLetterDigits = false

        for (index, digit) in digits.enumerated() {
            let power = "\(base.radix)" + UnicodeNotation.superscriptText(highestExponent - index)
            symbolicTerms.append("\(digit)·\(power)")

            if let digitValue = digit.hexDigitValue, digit.isLetter {
                hasLetterDigits = true
                numericTerms.append("\(digitValue)\(NumberBase.decimal.subscriptLabel)·\(power)")
            } else {
                numericTerms.append("\(digit)·\(power)")
            }
        }

        var parts = [notation(of: value, in: base), joined(symbolicTerms)]
        // Buchstabenziffern bekommen – wie in der Vorlage – eine Zwischenzeile
        // mit ihrem Dezimalwert.
        if hasLetterDigits {
            parts.append(joined(numericTerms))
        }
        parts.append(notation(of: value, in: .decimal))
        return parts.joined(separator: " = ")
    }

    private static func joined(_ terms: [String]) -> String {
        guard terms.count > maximumTerms else { return terms.joined(separator: " + ") }
        let head = Array(terms.prefix(5))
        let tail = Array(terms.suffix(2))
        return (head + ["…"] + tail).joined(separator: " + ")
    }
}
