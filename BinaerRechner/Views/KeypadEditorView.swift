import SwiftUI

/// Input for one number system: a keypad, stepping via the Digital Crown or
/// the − and + buttons, plus a live preview of the other systems.
///
/// This edits the shared value directly – appending a digit is nothing but
/// "value · radix + digit".
struct KeypadEditorView: View {
    let base: NumberBase
    let model: ConverterModel

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                currentValue
                stepper
                keypad
                controls
                preview
            }
            .padding(.horizontal, 2)
        }
        .navigationTitle(base.name)
    }

    // MARK: - Building blocks

    private var currentValue: some View {
        Text(model.displayText(for: base))
            .font(.system(.title2, design: .monospaced))
            .lineLimit(2)
            .minimumScaleFactor(0.4)
            .allowsTightening(true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(base.tint.opacity(0.18), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .accessibilityLabel("\(base.name) \(model.rawText(for: base))")
    }

    private var stepper: some View {
        Stepper(onIncrement: { step(by: 1) }, onDecrement: { step(by: -1) }) {
            Text("± 1")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .accessibilityLabel("Wert ändern")
    }

    private var keypad: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(base.keypadDigits, id: \.self) { digit in
                Button {
                    append(digit)
                } label: {
                    Text(String(digit))
                        .font(.system(.body, design: .monospaced))
                        .frame(maxWidth: .infinity, minHeight: 30)
                }
                .buttonStyle(.bordered)
                .tint(base.tint)
            }
        }
    }

    private var controls: some View {
        HStack(spacing: 4) {
            Button {
                if model.removeLastDigit(in: base) { Haptics.tap() } else { Haptics.limit() }
            } label: {
                Image(systemName: "delete.left")
                    .frame(maxWidth: .infinity, minHeight: 30)
            }
            .buttonStyle(.bordered)
            .accessibilityLabel("Letzte Stelle löschen")

            Button {
                Haptics.tap()
                model.reset()
            } label: {
                Text("C")
                    .font(.system(.body, design: .monospaced))
                    .frame(maxWidth: .infinity, minHeight: 30)
            }
            .buttonStyle(.bordered)
            .accessibilityLabel("Alles löschen")

            Button {
                Haptics.confirm()
                dismiss()
            } label: {
                Image(systemName: "checkmark")
                    .frame(maxWidth: .infinity, minHeight: 30)
            }
            .buttonStyle(.borderedProminent)
            .tint(base.tint)
            .accessibilityLabel("Fertig")
        }
    }

    /// The three other notations as a live preview.
    private var preview: some View {
        VStack(alignment: .leading, spacing: 1) {
            ForEach(NumberBase.displayOrder.filter { $0 != base }) { other in
                HStack(spacing: 4) {
                    Text(other.shortName)
                        .font(.caption2)
                        .foregroundStyle(other.tint)
                        .frame(width: 30, alignment: .leading)
                    Text(model.displayText(for: other))
                        .font(.system(.caption, design: .monospaced))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer(minLength: 0)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 2)
    }

    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 4), count: base.keypadColumns)
    }

    // MARK: - Actions

    private func append(_ digit: Character) {
        if model.appendDigit(digit, in: base) {
            Haptics.tap()
        } else {
            Haptics.limit()
        }
    }

    private func step(by delta: Int) {
        if model.step(by: delta) {
            Haptics.tap()
        } else {
            Haptics.limit()
        }
    }
}

#Preview {
    NavigationStack {
        KeypadEditorView(base: .hexadecimal, model: ConverterModel(value: 15))
    }
}
