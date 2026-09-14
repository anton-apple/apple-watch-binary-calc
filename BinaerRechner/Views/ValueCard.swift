import SwiftUI

/// One input field from the reference page: caption, value, tinted background.
struct ValueCard: View {
    let base: NumberBase
    let text: String

    var body: some View {
        HStack(spacing: 6) {
            VStack(alignment: .leading, spacing: 1) {
                Text(base.name)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(text)
                    .font(.system(.title3, design: .monospaced))
                    .lineLimit(2)
                    .minimumScaleFactor(0.4)
                    .allowsTightening(true)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.forward")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(base.tint.opacity(0.18), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(base.tint.opacity(0.55), lineWidth: 1)
        }
        .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(base.name)
        .accessibilityValue(text)
        .accessibilityHint("Zum Bearbeiten antippen")
    }
}

#Preview {
    VStack {
        ValueCard(base: .decimal, text: "15")
        ValueCard(base: .binary, text: "1111")
    }
}
