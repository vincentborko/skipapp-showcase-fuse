// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `onScrollPhaseChange(_:)`.
///
/// The modifier fires its callback with the old and new `ScrollPhase` whenever the scroll view's
/// phase changes. As you interact with the list below, the sticky header reflects the live phase:
///   • `idle`        — at rest, no touch
///   • `tracking`    — finger down on the content but not yet dragging
///   • `interacting` — actively dragging the content
///   • `decelerating`— finger lifted, content still coasting (a fling)
/// Touch and drag, then flick and release: watch the badge move tracking → interacting →
/// decelerating → idle. The header also logs the most recent transitions so the sequence is visible.
///
/// Note: `onScrollPhaseChange` is iOS 18+. On Android the phase is derived from pointer-pressed
/// state plus Compose's `isScrollInProgress`, which faithfully distinguishes tracking / interacting
/// / decelerating / idle. SwiftUI's `.animating` phase (programmatic scrolls) is not reported on
/// Android — there is no distinct Compose signal for it on this path.
struct ScrollPhaseChangePlayground: View {
    // NOTE: Skip cannot bridge `private` @State — keep these internal.
    @State var currentPhaseName = "idle"
    @State var isScrolling = false
    @State var transitions: [String] = []

    private let rowCount = 50

    var body: some View {
        VStack(spacing: 0) {
            // Sticky header (outside the ScrollView) reflects the live phase.
            VStack(alignment: .leading, spacing: 8) {
                if #available(iOS 18.0, *) {
                    HStack(spacing: 10) {
                        Text("Phase:")
                            .font(.headline)
                        phaseBadge(currentPhaseName)
                        Spacer()
                        Text(isScrolling ? "scrolling" : "at rest")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text("Recent: \(transitions.suffix(4).joined(separator: " → "))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                } else {
                    Text("onScrollPhaseChange requires iOS 18+")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(white: 0.95))

            Divider()

            phaseTrackingScrollView
        }
        .toolbar {
            PlaygroundSourceLink(file: "ScrollPhaseChangePlayground.swift")
        }
    }

    @ViewBuilder private var phaseTrackingScrollView: some View {
        let scroll = ScrollView {
            VStack(spacing: 8) {
                ForEach(0..<rowCount, id: \.self) { index in
                    Text("Row \(index)")
                        .font(.body)
                        .monospacedDigit()
                        .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                        .padding(.horizontal, 12)
                        .background(Color.blue.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding()
        }

        if #available(iOS 18.0, *) {
            scroll.onScrollPhaseChange { _, newPhase in
                let name = ScrollPhaseChangePlayground.name(for: newPhase)
                currentPhaseName = name
                isScrolling = newPhase.isScrolling
                transitions.append(name)
                if transitions.count > 12 {
                    transitions.removeFirst(transitions.count - 12)
                }
            }
        } else {
            scroll
        }
    }

    @ViewBuilder private func phaseBadge(_ name: String) -> some View {
        Text(name)
            .font(.subheadline.bold())
            .monospaced()
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(ScrollPhaseChangePlayground.color(for: name))
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }

    // Use equality rather than a switch: `ScrollPhase` is frozen in SkipSwiftUI but Apple's is
    // resilient, so a `switch` would need `@unknown default` on iOS yet warn on Android. `Hashable`
    // equality compiles cleanly on both legs of the dual-compiled showcase.
    @available(iOS 18.0, *)
    static func name(for phase: ScrollPhase) -> String {
        if phase == .interacting { return "interacting" }
        if phase == .tracking { return "tracking" }
        if phase == .decelerating { return "decelerating" }
        if phase == .animating { return "animating" }
        return "idle"
    }

    static func color(for name: String) -> Color {
        switch name {
        case "interacting": return .green
        case "tracking": return .orange
        case "decelerating": return .blue
        case "animating": return .purple
        default: return .gray
        }
    }
}
