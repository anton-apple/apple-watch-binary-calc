import Foundation

/// Turns digit strings into numbers and back.
///
/// Everything is computed in `UInt64`, so whole numbers from 0 up to
/// 18,446,744,073,709,551,615 (64 bit).
enum NumberParser {
    /// Reads a digit string in the given radix.
    ///
    /// - Returns: The value, or `nil` if the input contains an invalid digit
    ///   or would exceed `UInt64.max`.
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

    /// Writes a value as a digit string in the given radix (uppercase).
    static func format(_ value: UInt64, base: NumberBase) -> String {
        String(value, radix: base.radix, uppercase: true)
    }

    /// Like `format(_:base:)`, but split into blocks for readability –
    /// binary numbers are grouped into nibbles.
    static func formatGrouped(_ value: UInt64, base: NumberBase) -> String {
        grouped(format(value, base: base), base: base)
    }

    /// Inserts the separators into an already formatted digit string.
    static func grouped(_ digits: String, base: NumberBase) -> String {
        guard let size = base.groupSize, digits.count > size else { return digits }
        let total = digits.count
        var result = ""
        for (index, character) in digits.enumerated() {
            if index > 0, (total - index) % size == 0 {
                result.append("\u{2009}") // thin space
            }
            result.append(character)
        }
        return result
    }

    /// How many digits the value needs in this radix.
    static func digitCount(_ value: UInt64, base: NumberBase) -> Int {
        format(value, base: base).count
    }
}
