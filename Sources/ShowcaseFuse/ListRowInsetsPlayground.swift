// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `.listRowInsets(_:)`, which replaces the default content margins
/// of a `List` row with a custom `EdgeInsets`.
///
/// To make the effect observable, every row gets a contrasting `.listRowBackground`
/// (which fills the *entire* row bounds) and a label with its own background. The
/// gap between the row background and the label background is exactly the row insets,
/// so you can see the content pull toward (or away from) each edge as the insets change.
struct ListRowInsetsPlayground: View {
    // internal (not private) so Skip can bridge the @State across to Compose.
    @State var leading: Double = 16
    @State var top: Double = 8

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("listRowInsets replaces a row's default content margins. The blue band is the full row; the green label is its content. The space between them is the row insets.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                HStack {
                    Text("Leading: \(Int(leading))")
                        .font(.caption.monospacedDigit())
                        .frame(width: 90, alignment: .leading)
                    Slider(value: $leading, in: 0...64)
                }
                HStack {
                    Text("Top/Bot: \(Int(top))")
                        .font(.caption.monospacedDigit())
                        .frame(width: 90, alignment: .leading)
                    Slider(value: $top, in: 0...40)
                }
            }
            .padding()

            List {
                Section("Adjustable (driven by sliders above)") {
                    rowLabel("Custom insets")
                        .listRowInsets(EdgeInsets(top: top, leading: leading, bottom: top, trailing: leading))
                        .listRowBackground(Color.blue.opacity(0.25))
                }

                Section("Fixed comparisons") {
                    rowLabel("Default insets (no modifier)")
                        .listRowBackground(Color.blue.opacity(0.25))

                    rowLabel("Zero insets — full-bleed content")
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.blue.opacity(0.25))

                    rowLabel("Wide insets (48 leading)")
                        .listRowInsets(EdgeInsets(top: 12, leading: 48, bottom: 12, trailing: 12))
                        .listRowBackground(Color.blue.opacity(0.25))
                }
            }
        }
        .toolbar {
            PlaygroundSourceLink(file: "ListRowInsetsPlayground.swift")
        }
    }

    private func rowLabel(_ text: String) -> some View {
        Text(text)
            .font(.callout)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.green.opacity(0.4))
    }
}
