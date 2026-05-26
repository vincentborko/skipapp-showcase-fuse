// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `.controlSize(_:)`, which scales the size of controls. On Android (Skip)
/// it is currently honored by `Button` — each size scales the button's content padding and
/// its label font. Pick a size to resize the live buttons, or compare all five side by side.
///
/// Note: `controlSize` is scoped to controls — plain `Text` is unaffected. Other Material
/// controls (Toggle, Picker, …) keep their platform-default sizing for now.
struct ControlSizePlayground: View {
    // internal (not private) so Skip can bridge the @State across to Compose.
    @State var selectedSize: ControlSizeOption = .regular

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("controlSize scales controls. Choose a size and watch the buttons below grow or shrink (padding + label font).")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Picker("Control Size", selection: $selectedSize) {
                    ForEach(ControlSizeOption.allCases, id: \.self) { option in
                        Text(option.shortLabel).tag(option)
                    }
                }
                .pickerStyle(.segmented)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Live — buttons at .\(selectedSize.shortLabel)")
                        .font(.headline)
                    HStack(spacing: 12) {
                        Button("Bordered") {}
                            .buttonStyle(.bordered)
                        Button("Prominent") {}
                            .buttonStyle(.borderedProminent)
                    }
                    .controlSize(selectedSize.size)
                    Button("Plain text button") {}
                        .controlSize(selectedSize.size)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.12))

                Divider()

                Text("All five sizes side by side:")
                    .font(.headline)

                // Each row forces one size so the differences are directly comparable.
                ForEach(ControlSizeOption.allCases, id: \.self) { option in
                    HStack(spacing: 12) {
                        Text(option.shortLabel)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(width: 88, alignment: .leading)
                        Button("Action") {}
                            .buttonStyle(.borderedProminent)
                            .controlSize(option.size)
                        Spacer()
                    }
                }
            }
            .padding()
        }
        .toolbar {
            PlaygroundSourceLink(file: "ControlSizePlayground.swift")
        }
    }
}

/// Wrapper so the picker/list have a `CaseIterable`, labelled value;
/// maps to the real `ControlSize` applied to each sample.
enum ControlSizeOption: CaseIterable, Hashable {
    case mini
    case small
    case regular
    case large
    case extraLarge

    var size: ControlSize {
        switch self {
        case .mini: return .mini
        case .small: return .small
        case .regular: return .regular
        case .large: return .large
        case .extraLarge: return .extraLarge
        }
    }

    var shortLabel: String {
        switch self {
        case .mini: return "mini"
        case .small: return "small"
        case .regular: return "regular"
        case .large: return "large"
        case .extraLarge: return "extraLarge"
        }
    }
}
