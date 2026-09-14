import Foundation
import Observation

/// Holds the current value. The four number systems are only different
/// notations for the same value, so a single source is enough.
@Observable
final class ConverterModel {
    private static let storageKey = "de.binaerrechner.lastValue"

    private(set) var value: UInt64

    init(value: UInt64? = nil) {
        if let value {
            self.value = value
        } else if let stored = UserDefaults.standard.string(forKey: Self.storageKey),
                  let restored = UInt64(stored) {
            self.value = restored
        } else {
            self.value = 0
        }
    }

    /// Digit string for display (binary numbers grouped into nibbles).
    func displayText(for base: NumberBase) -> String {
        NumberParser.formatGrouped(value, base: base)
    }

    /// Digit string without separators – this is what gets edited.
    func rawText(for base: NumberBase) -> String {
        NumberParser.format(value, base: base)
    }

    var explanation: ConversionExplanation {
        ConversionExplanation(value: value)
    }

    func update(to newValue: UInt64) {
        guard newValue != value else { return }
        value = newValue
        persist()
    }

    /// Accepts an input if it is valid in the given radix.
    @discardableResult
    func update(from text: String, base: NumberBase) -> Bool {
        guard let parsed = NumberParser.parse(text, base: base) else { return false }
        update(to: parsed)
        return true
    }

    /// Raises or lowers the value by 1, staying inside the valid range.
    /// - Returns: `false` if the limit (0 or `UInt64.max`) was already reached.
    @discardableResult
    func step(by delta: Int) -> Bool {
        let magnitude = UInt64(delta.magnitude)
        let next: UInt64
        if delta >= 0 {
            let (sum, overflow) = value.addingReportingOverflow(magnitude)
            guard !overflow else { return false }
            next = sum
        } else {
            guard value >= magnitude else { return false }
            next = value - magnitude
        }
        guard next != value else { return false }
        update(to: next)
        return true
    }

    /// Appends a digit to the notation in `base` – which is exactly a
    /// multiplication by the radix plus the digit's value.
    /// - Returns: `false` if the digit does not fit the radix or the value
    ///   range would be exceeded.
    @discardableResult
    func appendDigit(_ digit: Character, in base: NumberBase) -> Bool {
        guard let digitValue = digit.hexDigitValue, digitValue < base.radix else { return false }
        let radix = UInt64(base.radix)
        let (shifted, shiftOverflow) = value.multipliedReportingOverflow(by: radix)
        guard !shiftOverflow else { return false }
        let (sum, sumOverflow) = shifted.addingReportingOverflow(UInt64(digitValue))
        guard !sumOverflow else { return false }
        update(to: sum)
        return true
    }

    /// Drops the last digit of the notation in `base`.
    @discardableResult
    func removeLastDigit(in base: NumberBase) -> Bool {
        guard value > 0 else { return false }
        update(to: value / UInt64(base.radix))
        return true
    }

    func reset() {
        update(to: 0)
    }

    private func persist() {
        UserDefaults.standard.set(String(value), forKey: Self.storageKey)
    }
}
