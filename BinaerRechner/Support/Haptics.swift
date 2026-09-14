import WatchKit

/// Kurze Rückmeldungen am Handgelenk – ohne Haptik fühlt sich das Tastenfeld
/// auf der Uhr tot an.
enum Haptics {
    static func tap() {
        WKInterfaceDevice.current().play(.click)
    }

    static func limit() {
        WKInterfaceDevice.current().play(.failure)
    }

    static func confirm() {
        WKInterfaceDevice.current().play(.success)
    }
}
