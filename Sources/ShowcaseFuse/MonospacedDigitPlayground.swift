// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `monospacedDigit()` — tabular figures that give every digit the
/// same advance width, so a changing number's digit columns don't jitter.
///
/// Drag the slider and watch the right edge of each number. The plain rows shift
/// horizontally as proportional digits (1 is narrower than 8) change; the
/// monospaced rows stay rock-steady.
///
/// Three API surfaces are exercised:
///   • `Font.monospacedDigit()`   — `.font(.title2.monospacedDigit())`
///   • `View.monospacedDigit()`   — applied to any view
///   • `Text.monospacedDigit()`   — applied to a `Text` value
struct MonospacedDigitPlayground: View {
    // internal (not private) so Skip can bridge the @State across to Compose.
    @State var amount: Double = 0

    private var value: Int { Int(amount) }
    // A value with a mix of wide/narrow digits makes proportional jitter obvious.
    private var display: String { "\(value)" }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Drag the slider. Watch the right edge of each number: plain rows jitter as digit widths change, monospaced rows hold their columns.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Slider(value: $amount, in: 0...199999)

                comparisonRow(
                    title: "Font.monospacedDigit()",
                    plain: Text(display).font(.title2),
                    mono: Text(display).font(.title2.monospacedDigit())
                )

                comparisonRow(
                    title: "View.monospacedDigit()",
                    plain: Text(display).font(.title2),
                    mono: AnyView(Text(display).font(.title2).monospacedDigit())
                )

                comparisonRow(
                    title: "Text.monospacedDigit()",
                    plain: Text(display).font(.title2),
                    mono: Text(display).monospacedDigit().font(.title2)
                )

                Divider()

                // A stopwatch-style readout: the classic case for tabular figures.
                VStack(alignment: .leading, spacing: 8) {
                    Text("Stopwatch readout (mono):")
                        .font(.headline)
                    Text(stopwatch)
                        .font(.system(size: 40, weight: .semibold).monospacedDigit())
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(Color.gray.opacity(0.15))
                }
            }
            .padding()
        }
        .toolbar {
            PlaygroundSourceLink(file: "MonospacedDigitPlayground.swift")
        }
    }

    /// mm:ss.cs derived from the slider so it reads like a running timer.
    private var stopwatch: String {
        let total = value
        let minutes = (total / 6000) % 60
        let seconds = (total / 100) % 60
        let centis = total % 100
        return String(format: "%02d:%02d.%02d", minutes, seconds, centis)
    }

    // A plain (proportional) row above a monospaced row, both right-aligned in a
    // fixed-width frame so the moving right edge is the thing you compare.
    private func comparisonRow(title: String, plain: some View, mono: some View) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack {
                Text("plain")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(width: 44, alignment: .leading)
                plain
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            HStack {
                Text("mono")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(width: 44, alignment: .leading)
                mono
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.vertical, 4)
    }
}
