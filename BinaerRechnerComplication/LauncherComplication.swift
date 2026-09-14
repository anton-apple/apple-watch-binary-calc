import SwiftUI
import WidgetKit

/// A complication for the watch face whose only job is to launch the app.
///
/// It shows no value: a widget extension runs in its own process with its own
/// container, so reading the app's stored number would require an App Group
/// and the matching entitlement. Launching is what this is for.
@main
struct LauncherComplication: Widget {
    private let kind = "BinaerRechnerLauncher"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: LauncherProvider()) { _ in
            LauncherComplicationView()
                .containerBackground(for: .widget) {
                    AccessoryWidgetBackground()
                }
        }
        .configurationDisplayName("Zahlen")
        .description("Öffnet den Zahlenkonverter direkt vom Zifferblatt.")
        .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryInline, .accessoryRectangular])
    }
}

struct LauncherEntry: TimelineEntry {
    let date: Date
}

/// The complication never changes, so a single entry that is never reloaded
/// is enough – that keeps it off the watch's update budget entirely.
struct LauncherProvider: TimelineProvider {
    func placeholder(in context: Context) -> LauncherEntry {
        LauncherEntry(date: .now)
    }

    func getSnapshot(in context: Context, completion: @escaping (LauncherEntry) -> Void) {
        completion(LauncherEntry(date: .now))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LauncherEntry>) -> Void) {
        completion(Timeline(entries: [LauncherEntry(date: .now)], policy: .never))
    }
}
