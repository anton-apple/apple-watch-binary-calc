import SwiftUI

/// Ein Zahlensystem, das der Rechner anzeigen und einlesen kann.
///
/// Der `rawValue` ist gleichzeitig die Basis (Radix) des Zahlensystems.
enum NumberBase: Int, CaseIterable, Identifiable, Codable {
    case decimal = 10
    case binary = 2
    case hexadecimal = 16
    case octal = 8

    var id: Int { rawValue }

    /// Basis des Zahlensystems, z. B. 16 für Hexadezimal.
    var radix: Int { rawValue }

    /// Reihenfolge der Eingabefelder – wie auf der Vorlage: Dezimal, Binär, Hexadezimal, Oktal.
    static let displayOrder: [NumberBase] = [.decimal, .binary, .hexadecimal, .octal]

    /// Reihenfolge der Rechenwege – dort fehlt Dezimal, weil es keinen Umweg gibt.
    static let explanationOrder: [NumberBase] = [.hexadecimal, .octal, .binary]

    var name: String {
        switch self {
        case .decimal: "Dezimal"
        case .binary: "Binär"
        case .hexadecimal: "Hexadezimal"
        case .octal: "Oktal"
        }
    }

    var shortName: String {
        switch self {
        case .decimal: "DEZ"
        case .binary: "BIN"
        case .hexadecimal: "HEX"
        case .octal: "OKT"
        }
    }

    /// Farbe der Vorlage: Dezimal gelb, Binär grün, Hexadezimal cyan, Oktal rosa.
    var tint: Color {
        switch self {
        case .decimal: .yellow
        case .binary: .green
        case .hexadecimal: .cyan
        case .octal: .pink
        }
    }

    /// Alle in diesem Zahlensystem erlaubten Ziffern, aufsteigend.
    var digits: [Character] {
        Array("0123456789ABCDEF".prefix(radix))
    }

    /// Ziffern in der Reihenfolge, in der sie auf dem Tastenfeld stehen.
    var keypadDigits: [Character] {
        switch self {
        case .decimal: Array("1234567890")
        default: digits
        }
    }

    /// Spaltenanzahl des Tastenfelds, damit die Ziffern eine volle Rechteckfläche ergeben.
    var keypadColumns: Int {
        switch self {
        case .binary: 2
        case .decimal: 3
        case .octal, .hexadecimal: 4
        }
    }

    /// Ziffern werden zur besseren Lesbarkeit in Blöcke dieser Größe geteilt.
    var groupSize: Int? {
        switch self {
        case .binary: 4
        case .hexadecimal, .octal, .decimal: nil
        }
    }

    /// Tiefgestellte Basis für die Schreibweise, z. B. „₁₆“.
    var subscriptLabel: String { UnicodeNotation.subscriptText(radix) }

    func allows(_ character: Character) -> Bool {
        guard let value = character.hexDigitValue else { return false }
        return value < radix
    }
}
