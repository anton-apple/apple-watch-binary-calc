import WatchKit

/// Short feedback on the wrist – without haptics the keypad feels dead
/// on a watch.
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
