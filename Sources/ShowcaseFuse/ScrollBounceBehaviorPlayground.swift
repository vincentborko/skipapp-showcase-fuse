// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `.scrollBounceBehavior(_:axes:)`.
///
/// On Android the iOS "bounce" past a content edge is the **stretch overscroll**.
/// Compose shows that stretch even when the content already fits the scroll view
/// (unlike iOS, which only bounces a too-small scroll view when `alwaysBounce` is
/// set). `.basedOnSize` means "don't bounce when the content fits", so when it's
/// applied to the active axis and the content isn't actually scrollable, the
/// stretch is suppressed. `.automatic`/`.always` keep the platform default.
///
/// The rows below all hold content that *fits* on screen (so they aren't
/// scrollable). Drag/pull them sideways: `.always` stretches, `.basedOnSize`
/// stays put. This is only observable during an interactive over-drag — a static
/// screenshot won't show it.
struct ScrollBounceBehaviorPlayground: View {
    // internal (not private) so Skip can bridge the @State across to Compose.
    @State var selected: BounceBehaviorOption = .basedOnSize

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Each row's items fit on screen, so the row can't scroll. Drag it sideways to over-pull: `.always` shows the stretch, `.basedOnSize` doesn't.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Live (pick a behavior, then drag the row):")
                    .font(.headline)

                Picker("Bounce Behavior", selection: $selected) {
                    Text(".automatic").tag(BounceBehaviorOption.automatic)
                    Text(".always").tag(BounceBehaviorOption.always)
                    Text(".basedOnSize").tag(BounceBehaviorOption.basedOnSize)
                }
                .pickerStyle(.segmented)

                shortRow(color: .blue)
                    .scrollBounceBehavior(selected.value, axes: .horizontal)
                    .frame(height: 80)
                    .background(Color.gray.opacity(0.15))

                Divider()

                Text("Side by side (drag each to compare):")
                    .font(.headline)

                ForEach(BounceBehaviorOption.allCases, id: \.self) { option in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(option.label)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        shortRow(color: option.color)
                            .scrollBounceBehavior(option.value, axes: .horizontal)
                            .frame(height: 72)
                            .background(option.color.opacity(0.1))
                    }
                }
            }
            .padding()
        }
        .toolbar {
            PlaygroundSourceLink(file: "ScrollBounceBehaviorPlayground.swift")
        }
    }

    // A horizontal ScrollView whose few items fit on screen — so it isn't
    // scrollable, which is exactly the case `.basedOnSize` affects.
    @ViewBuilder func shortRow(color: Color) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(0.35))
                        .frame(width: 56, height: 56)
                        .overlay(Text("\(i)").font(.headline))
                }
            }
            .padding(.horizontal)
        }
    }
}

/// Labelled, `CaseIterable` wrapper so the picker/list can iterate; maps to the
/// real `ScrollBounceBehavior` applied to each row.
enum BounceBehaviorOption: CaseIterable, Hashable {
    case automatic
    case always
    case basedOnSize

    var value: ScrollBounceBehavior {
        switch self {
        case .automatic: return .automatic
        case .always: return .always
        case .basedOnSize: return .basedOnSize
        }
    }

    var label: String {
        switch self {
        case .automatic: return ".automatic — platform default (stretches on Android)"
        case .always: return ".always — always stretches on over-drag"
        case .basedOnSize: return ".basedOnSize — no stretch when content fits"
        }
    }

    var color: Color {
        switch self {
        case .automatic: return .purple
        case .always: return .orange
        case .basedOnSize: return .green
        }
    }
}
