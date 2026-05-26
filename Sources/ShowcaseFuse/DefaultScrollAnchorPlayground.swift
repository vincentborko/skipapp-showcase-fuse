// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `.defaultScrollAnchor(_:)`, which sets the *initial* resting
/// position of a `ScrollView` once its content is laid out — e.g. `.bottom`
/// opens a long list already scrolled to the newest content (chat transcripts).
///
/// To make the effect observable: the scroll view holds 40 numbered rows (far
/// more than fit on screen) and is tagged with `.id(anchor)`. Changing the
/// segmented picker recreates the scroll view, so the chosen anchor is applied
/// fresh and you can watch where it comes to rest:
///   • `.top`    → opens showing Row 1 (the default, no scrolling).
///   • `.center` → opens scrolled to the middle (~Row 20).
///   • `.bottom` → opens scrolled to the end (Row 40 visible).
/// After it settles you can still scroll freely — the anchor only governs the
/// initial position, never fighting later user scrolling.
struct DefaultScrollAnchorPlayground: View {
    // internal (not private) so Skip can bridge the @State across to Compose.
    @State var anchor: AnchorChoice = .bottom

    enum AnchorChoice: String, CaseIterable, Identifiable {
        case top, center, bottom
        var id: String { rawValue }
        var unitPoint: UnitPoint {
            switch self {
            case .top: return .top
            case .center: return .center
            case .bottom: return .bottom
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("defaultScrollAnchor sets where a ScrollView rests when it first appears. Pick an anchor — the list below is recreated and opens at that position.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Picker("Anchor", selection: $anchor) {
                    ForEach(AnchorChoice.allCases) { choice in
                        Text(choice.rawValue.capitalized).tag(choice)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding()

            if #available(iOS 17.0, *) {
                ScrollView {
                    LazyVStack(spacing: 4) {
                        ForEach(1...40, id: \.self) { i in
                            Text("Row \(i)")
                                .font(.callout.monospacedDigit())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 14)
                                .background(i % 2 == 0 ? Color.blue.opacity(0.18) : Color.green.opacity(0.18))
                        }
                    }
                    .padding(.horizontal)
                }
                // Re-create the scroll view when the anchor changes so the initial
                // anchor is applied fresh (it only takes effect on first layout).
                .defaultScrollAnchor(anchor.unitPoint)
                .id(anchor)
            } else {
                Text("defaultScrollAnchor requires iOS 17.0 or newer")
                    .foregroundStyle(.secondary)
                    .frame(maxHeight: .infinity)
            }
        }
        .toolbar {
            PlaygroundSourceLink(file: "DefaultScrollAnchorPlayground.swift")
        }
    }
}
