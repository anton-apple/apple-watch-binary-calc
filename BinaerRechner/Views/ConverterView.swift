import SwiftUI

/// Main screen: all four notations stacked, with the worked example below.
/// Tapping a field opens the matching keypad.
struct ConverterView: View {
    @State private var model = ConverterModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(NumberBase.displayOrder) { base in
                        NavigationLink {
                            KeypadEditorView(base: base, model: model)
                        } label: {
                            ValueCard(base: base, text: model.displayText(for: base))
                        }
                        .buttonStyle(.plain)
                    }

                    explanation

                    Button(role: .destructive) {
                        Haptics.tap()
                        model.reset()
                    } label: {
                        Label("Zurücksetzen", systemImage: "arrow.counterclockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .padding(.top, 4)
                }
                .padding(.horizontal, 2)
            }
            .navigationTitle("Zahlen")
        }
    }

    private var explanation: some View {
        let details = model.explanation
        return VStack(alignment: .leading, spacing: 8) {
            Divider()
                .padding(.vertical, 2)

            VStack(alignment: .leading, spacing: 2) {
                Text("Übersicht")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                Text(details.overview)
                    .font(.system(.footnote, design: .monospaced))
                    .minimumScaleFactor(0.6)
                    .allowsTightening(true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(details.steps) { step in
                ExplanationSection(step: step)
            }
        }
    }
}

#Preview {
    ConverterView()
}
