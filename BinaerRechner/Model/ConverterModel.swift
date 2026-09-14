import Foundation
import Observation

/// Hält den aktuellen Wert. Alle vier Zahlensysteme sind nur unterschiedliche
/// Schreibweisen desselben Werts, deshalb genügt eine einzige Quelle.
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

    /// Ziffernfolge für die Anzeige (Binärzahlen in Vierergruppen).
    func displayText(for base: NumberBase) -> String {
        NumberParser.formatGrouped(value, base: base)
    }

    /// Ziffernfolge ohne Trennzeichen – so wird sie bearbeitet.
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

    /// Übernimmt eine Eingabe, wenn sie in der Basis gültig ist.
    @discardableResult
    func update(from text: String, base: NumberBase) -> Bool {
        guard let parsed = NumberParser.parse(text, base: base) else { return false }
        update(to: parsed)
        return true
    }

    /// Erhöht oder verringert den Wert um 1 und bleibt dabei im gültigen Bereich.
    /// - Returns: `false`, wenn die Grenze (0 bzw. `UInt64.max`) bereits erreicht war.
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

    /// Hängt eine Ziffer an die Darstellung in `base` an – das ist genau eine
    /// Multiplikation mit der Basis plus dem Ziffernwert.
    /// - Returns: `false`, wenn die Ziffer nicht in die Basis passt oder der
    ///   Wertebereich überschritten würde.
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

    /// Entfernt die letzte Stelle der Darstellung in `base`.
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
