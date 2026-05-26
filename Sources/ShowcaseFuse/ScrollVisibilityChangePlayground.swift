// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `onScrollVisibilityChange(threshold:_:)`.
///
/// The modifier fires its callback with a `Bool` whenever the modified view's visible fraction
/// within the scroll view crosses `threshold` (default 0.5). Each row below reports its *own*
/// visibility back into `@State`, so a row's badge flips between "visible" and "hidden" as it
/// scrolls into / out of the viewport — and the sticky header tallies how many rows are currently
/// considered visible. Watch the badges flip and the count change as you scroll.
///
/// `threshold` is exercised three ways on the highlighted tracker rows: 0.1 (any sliver counts),
/// 0.5 (half), and 0.9 (almost fully on-screen) — they flip at noticeably different scroll
/// positions near the top/bottom edges.
///
/// Note: `onScrollVisibilityChange` is iOS 18+. On Android, "visible" is approximated as the
/// fraction of the row that survives ancestor clipping (the scroll container clips by default),
/// which matches the common full-screen-scroll-view case.
struct ScrollVisibilityChangePlayground: View {
    // NOTE: Skip cannot bridge `private` @State — keep these internal.
    @State var visibleRows: Set<Int> = []
    @State var tracker10 = false
    @State var tracker50 = false
    @State var tracker90 = false

    private let rowCount = 40

    var body: some View {
        VStack(spacing: 0) {
            // Sticky header (outside the ScrollView) tallies the live visibility state.
            VStack(alignment: .leading, spacing: 4) {
                if #available(iOS 18.0, *) {
                    Text("Visible rows (≥50%): \(visibleRows.count)")
                        .font(.headline)
                        .monospacedDigit()
                    Text(visibleRangeDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                    HStack(spacing: 8) {
                        thresholdBadge("0.1", on: tracker10)
                        thresholdBadge("0.5", on: tracker50)
                        thresholdBadge("0.9", on: tracker90)
                    }
                } else {
                    Text("onScrollVisibilityChange requires iOS 18+")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(white: 0.95))

            Divider()

            ScrollView {
                VStack(spacing: 8) {
                    ForEach(0..<rowCount, id: \.self) { index in
                        row(index)
                    }
                }
                .padding()
            }
        }
        .toolbar {
            PlaygroundSourceLink(file: "ScrollVisibilityChangePlayground.swift")
        }
    }

    private var visibleRangeDescription: String {
        guard let lo = visibleRows.min(), let hi = visibleRows.max() else {
            return "none on screen"
        }
        return "topmost \(lo) … bottommost \(hi)"
    }

    @ViewBuilder private func thresholdBadge(_ label: String, on: Bool) -> some View {
        Text("t=\(label)")
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(on ? Color.orange : Color(white: 0.85))
            .foregroundStyle(on ? Color.white : Color.secondary)
            .clipShape(Capsule())
    }

    @ViewBuilder private func row(_ index: Int) -> some View {
        // One "tracker" row additionally drives the per-threshold badges in the header so the effect
        // of `threshold` is observable (t=0.1 stays on longest as it nears an edge, t=0.9 drops first);
        // every row drives the visible-count via threshold 0.5.
        let isVisible = visibleRows.contains(index)
        let isTracker = index == 20

        Text("Row \(index)\(isTracker ? "  ← tracker" : "")  —  \(isVisible ? "visible" : "hidden")")
            .font(.body)
            .monospacedDigit()
            .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
            .padding(.horizontal, 12)
            .background(isVisible ? Color.green.opacity(0.3) : Color.gray.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .modifier(VisibilityReporter(index: index, isTracker: isTracker,
                                         onHalf: { vis in
                                             if vis { visibleRows.insert(index) } else { visibleRows.remove(index) }
                                         },
                                         onTenth: { tracker10 = $0 },
                                         onHalfTracker: { tracker50 = $0 },
                                         onNinetieth: { tracker90 = $0 }))
    }
}

/// Wraps the iOS-18-gated `onScrollVisibilityChange` calls so the row builder stays readable.
/// Every row reports at threshold 0.5 (drives the count); the three tracker rows additionally
/// report at 0.1 / 0.5 / 0.9 to drive the header badges.
struct VisibilityReporter: ViewModifier {
    let index: Int
    let isTracker: Bool
    let onHalf: (Bool) -> Void
    let onTenth: (Bool) -> Void
    let onHalfTracker: (Bool) -> Void
    let onNinetieth: (Bool) -> Void

    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .onScrollVisibilityChange(threshold: 0.5) { onHalf($0) }
                .modifier(TrackerReporter(active: isTracker, onTenth: onTenth, onHalf: onHalfTracker, onNinetieth: onNinetieth))
        } else {
            content
        }
    }
}

@available(iOS 18.0, *)
struct TrackerReporter: ViewModifier {
    let active: Bool
    let onTenth: (Bool) -> Void
    let onHalf: (Bool) -> Void
    let onNinetieth: (Bool) -> Void

    func body(content: Content) -> some View {
        if active {
            content
                .onScrollVisibilityChange(threshold: 0.1) { onTenth($0) }
                .onScrollVisibilityChange(threshold: 0.5) { onHalf($0) }
                .onScrollVisibilityChange(threshold: 0.9) { onNinetieth($0) }
        } else {
            content
        }
    }
}
