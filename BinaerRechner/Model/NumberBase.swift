import SwiftUI

/// A number system the calculator can display and read.
///
/// The `rawValue` doubles as the radix of the number system.
enum NumberBase: Int, CaseIterable, Identifiable, Codable {
    case decimal = 10
    case binary = 2
    case hexadecimal = 16
    case octal = 8

    var id: Int { rawValue }

    /// Radix of the number system, e.g. 16 for hexadecimal.
    var radix: Int { rawValue }

    /// Order of the input fields, matching the reference page:
    /// decimal, binary, hexadecimal, octal.
    static let displayOrder: [NumberBase] = [.decimal, .binary, .hexadecimal, .octal]

    /// Order of the worked examples. Decimal is missing because there is
    /// nothing to convert.
    static let explanationOrder: [NumberBase] = [.hexadecimal, .octal, .binary]

    /// Displayed name. The app's interface is German, so these stay German.
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

    /// Colors of the reference page: decimal yellow, binary green,
    /// hexadecimal cyan, octal pink.
    var tint: Color {
        switch self {
        case .decimal: .yellow
        case .binary: .green
        case .hexadecimal: .cyan
        case .octal: .pink
        }
    }

    /// Every digit valid in this number system, ascending.
    var digits: [Character] {
        Array("0123456789ABCDEF".prefix(radix))
    }

    /// Digits in the order they appear on the keypad.
    var keypadDigits: [Character] {
        switch self {
        case .decimal: Array("1234567890")
        default: digits
        }
    }

    /// Number of keypad columns, chosen so the digits fill complete rows.
    var keypadColumns: Int {
        switch self {
        case .binary: 2
        case .decimal: 3
        case .octal, .hexadecimal: 4
        }
    }

    /// Digits are split into blocks of this size for readability.
    var groupSize: Int? {
        switch self {
        case .binary: 4
        case .hexadecimal, .octal, .decimal: nil
        }
    }

    /// The radix as a subscript, e.g. "₁₆".
    var subscriptLabel: String { UnicodeNotation.subscriptText(radix) }

    func allows(_ character: Character) -> Bool {
        guard let value = character.hexDigitValue else { return false }
        return value < radix
    }
}
