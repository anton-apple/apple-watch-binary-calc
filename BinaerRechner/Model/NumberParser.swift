import Foundation

/// Wandelt Ziffernfolgen in Zahlen um und wieder zurück.
///
/// Gerechnet wird durchgehend mit `UInt64`, also mit ganzen Zahlen von 0 bis
/// 18.446.744.073.709.551.615 (64 Bit).
enum NumberParser {
    /// Liest eine Ziffernfolge in der angegebenen Basis ein.
    ///
    /// - Returns: Den Wert oder `nil`, wenn die Eingabe eine ungültige Ziffer
    ///   enthält oder größer als `UInt64.max` wäre.
    static func parse(_ text: String, base: NumberBase) -> UInt64? {
        let cleaned = text.uppercased().filter { !$0.isWhitespace && $0 != "_" && $0 != "." }
        guard !cleaned.isEmpty else { return nil }

        let radix = UInt64(base.radix)
        var result: UInt64 = 0
        for character in cleaned {
            guard let digit = character.hexDigitValue, digit < base.radix else { return nil }
            let (shifted, shiftOverflow) = result.multipliedReportingOverflow(by: radix)
            guard !shiftOverflow else { return nil }
            let (sum, sumOverflow) = shifted.addingReportingOverflow(UInt64(digit))
            guard !sumOverflow else { return nil }
            result = sum
        }
        return result
    }

    /// Schreibt einen Wert als Ziffernfolge der angegebenen Basis (Großbuchstaben).
    static func format(_ value: UInt64, base: NumberBase) -> String {
        String(value, radix: base.radix, uppercase: true)
    }

    /// Wie `format(_:base:)`, aber mit Blöcken für die Lesbarkeit –
    /// Binärzahlen werden in Vierergruppen (Nibbles) getrennt.
    static func formatGrouped(_ value: UInt64, base: NumberBase) -> String {
        grouped(format(value, base: base), base: base)
    }

    /// Fügt in eine bereits fertige Ziffernfolge die Trennzeichen ein.
    static func grouped(_ digits: String, base: NumberBase) -> String {
        guard let size = base.groupSize, digits.count > size else { return digits }
        let total = digits.count
        var result = ""
        for (index, character) in digits.enumerated() {
            if index > 0, (total - index) % size == 0 {
                result.append("\u{2009}") // schmales Leerzeichen
            }
            result.append(character)
        }
        return result
    }

    /// Anzahl der Stellen, die der Wert in dieser Basis benötigt.
    static func digitCount(_ value: UInt64, base: NumberBase) -> Int {
        format(value, base: base).count
    }
}
