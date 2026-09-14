import SwiftUI
import WidgetKit

/// One layout per watch face slot. "10" is the app's mark – it reads as ten in
/// decimal and as two in binary, which is the whole point of the app.
struct LauncherComplicationView: View {
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .accessoryCircular:
            Text("10")
                .font(.system(.title2, design: .monospaced))
                .fontWeight(.semibold)
                .minimumScaleFactor(0.6)

        case .accessoryCorner:
            Text("10")
                .font(.system(.title3, design: .monospaced))
                .fontWeight(.semibold)
                .widgetLabel("Zahlen")

        case .accessoryInline:
            Label("Zahlen umrechnen", systemImage: "number")

        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                Text("Zahlen")
                    .font(.headline)
                    .widgetAccentable()
                Text("DEZ · BIN · HEX · OKT")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        default:
            Text("10")
                .font(.system(.body, design: .monospaced))
        }
    }
}
