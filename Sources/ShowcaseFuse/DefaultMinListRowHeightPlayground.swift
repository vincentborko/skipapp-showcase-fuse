// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates the `\.defaultMinListRowHeight` environment value (set via
/// `.environment(\.defaultMinListRowHeight, _)`), which sets the minimum height a
/// `List` lays each of its rows out at. SwiftUI has no dedicated convenience modifier
/// for it — it is purely an environment value.
///
/// To make the effect observable, every row holds only a single short line of text
/// (whose intrinsic height is well below any of the minimums here), and each row gets
/// a contrasting `.listRowBackground` so the *full row bounds* are visible. As the
/// minimum height grows, the colored bands get taller even though the text doesn't —
/// that extra space is the enforced minimum row height.
struct DefaultMinListRowHeightPlayground: View {
    // internal (not private) so Skip can bridge the @State across to Compose.
    @State var minHeight: Double = 32

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("defaultMinListRowHeight sets the floor on each List row's height. The text in every row is the same short line — the colored band grows because the minimum row height does.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                HStack {
                    Text("Min: \(Int(minHeight))")
                        .font(.caption.monospacedDigit())
                        .frame(width: 70, alignment: .leading)
                    Slider(value: $minHeight, in: 16...120)
                }
            }
            .padding()

            // Adjustable list — its min row height follows the slider.
            List {
                Section("Adjustable (min = \(Int(minHeight)))") {
                    band("Row A")
                    band("Row B")
                    band("Row C")
                }
            }
            .environment(\.defaultMinListRowHeight, CGFloat(minHeight))

            // Fixed comparison: a compact list right below, so the row-band heights
            // can be compared against the adjustable one above.
            List {
                Section("Fixed (min = 16, compact)") {
                    band("Row A")
                    band("Row B")
                }
            }
            .environment(\.defaultMinListRowHeight, 16)
        }
        .toolbar {
            PlaygroundSourceLink(file: "DefaultMinListRowHeightPlayground.swift")
        }
    }

    private func band(_ text: String) -> some View {
        Text(text)
            .font(.callout)
            .frame(maxWidth: .infinity, alignment: .leading)
            .listRowBackground(Color.blue.opacity(0.25))
    }
}
