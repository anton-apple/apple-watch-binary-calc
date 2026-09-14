import SwiftUI

/// Ein Abschnitt des Rechenwegs, z. B. „Oktal: 17₈ = 1·8¹ + 7·8⁰ = 15₁₀“.
struct ExplanationSection: View {
    let step: ConversionExplanation.Step

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(step.title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(step.base.tint)
            Text(step.text)
                .font(.system(.footnote, design: .monospaced))
                .minimumScaleFactor(0.6)
                .allowsTightening(true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ExplanationSection(step: ConversionExplanation(value: 15).steps[1])
}
