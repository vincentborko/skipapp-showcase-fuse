// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `dynamicTypeSize(_:)` — overriding the Dynamic Type (text) size for a view subtree.
///
/// Two overloads are exercised:
///   • `dynamicTypeSize(_ size: DynamicTypeSize)` — force a fixed category, ignoring the device setting.
///   • `dynamicTypeSize(_ range:)` (any `RangeExpression`) — clamp the device's size into a range.
///
/// Behavior to look for on the emulator: only `.sp`-based text rescales — fixed `.dp` layout
/// (frame widths, padding) stays put. The range rows pin their text regardless of the device's
/// system font-size setting: a low cap shrinks text, a high floor enlarges it.
struct DynamicTypeSizePlayground: View {
    // internal (not private) so Skip can bridge the @State across to Compose.
    @State var selected: DynamicTypeSize = .large

    private let sample = "The quick brown fox"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                // 1. Live picker: drag through the categories and watch the sample grow/shrink.
                VStack(alignment: .leading, spacing: 8) {
                    Text("Pick a size — the sample below is forced to it:")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Picker("Dynamic Type Size", selection: $selected) {
                        ForEach(DynamicTypeSizePlayground.pickable, id: \.self) { size in
                            Text(DynamicTypeSizePlayground.name(size)).tag(size)
                        }
                    }
                    .pickerStyle(.menu)
                    Text(sample)
                        .font(.title3)
                        .dynamicTypeSize(selected)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.blue.opacity(0.12))
                }

                Divider()

                // 2. Fixed sizes side by side — same text & .title3 font, different forced categories.
                VStack(alignment: .leading, spacing: 8) {
                    Text("Fixed sizes (same .title3 font):")
                        .font(.headline)
                    ForEach(DynamicTypeSizePlayground.showcase, id: \.self) { size in
                        HStack(alignment: .firstTextBaseline) {
                            Text(DynamicTypeSizePlayground.name(size))
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .frame(width: 96, alignment: .leading) // fixed .dp width: should NOT scale
                            Text(sample)
                                .font(.title3)
                                .dynamicTypeSize(size)
                        }
                    }
                }

                Divider()

                // 3. Range clamping — pins the value when the device size falls outside the bounds.
                VStack(alignment: .leading, spacing: 12) {
                    Text("Range clamping (.title3 base):")
                        .font(.headline)

                    clampRow("no clamp (device size)",
                             Text(sample).font(.title3))
                    clampRow("...small  (capped small)",
                             Text(sample).font(.title3).dynamicTypeSize(...DynamicTypeSize.small))
                    clampRow("large...xLarge  (clamped band)",
                             Text(sample).font(.title3).dynamicTypeSize(DynamicTypeSize.large...DynamicTypeSize.xLarge))
                    clampRow("accessibility3...  (floored)",
                             Text(sample).font(.title3).dynamicTypeSize(DynamicTypeSize.accessibility3...))
                }
            }
            .padding()
        }
        .toolbar {
            PlaygroundSourceLink(file: "DynamicTypeSizePlayground.swift")
        }
    }

    private func clampRow(_ label: String, _ content: some View) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            content
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 2)
    }

    // A readable subset for the live picker (skips redundant neighbors).
    static let pickable: [DynamicTypeSize] = [
        .xSmall, .small, .medium, .large, .xLarge, .xxLarge, .xxxLarge,
        .accessibility1, .accessibility3, .accessibility5
    ]

    static let showcase: [DynamicTypeSize] = [.xSmall, .large, .xxLarge, .accessibility2]

    static func name(_ size: DynamicTypeSize) -> String {
        switch size {
        case .xSmall: return "xSmall"
        case .small: return "small"
        case .medium: return "medium"
        case .large: return "large (default)"
        case .xLarge: return "xLarge"
        case .xxLarge: return "xxLarge"
        case .xxxLarge: return "xxxLarge"
        case .accessibility1: return "accessibility1"
        case .accessibility2: return "accessibility2"
        case .accessibility3: return "accessibility3"
        case .accessibility4: return "accessibility4"
        case .accessibility5: return "accessibility5"
        @unknown default: return "unknown"
        }
    }
}
