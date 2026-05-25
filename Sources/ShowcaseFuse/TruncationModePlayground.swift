// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `.truncationMode(_:)`, which controls where the ellipsis (…)
/// appears when single-line text is too long to fit its bounds.
///
/// Note: head/middle truncation only differ from tail when the text is limited
/// to a single line (`.lineLimit(1)`); multi-line text always tail-truncates.
struct TruncationModePlayground: View {
    // internal (not private) so Skip can bridge the @State across to Compose.
    @State var selectedMode: TruncationModeOption = .tail

    private let sampleText = "The quick brown fox jumps over the lazy dog near the river bank at dawn."

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("truncationMode chooses where the ellipsis falls when one-line text overflows. Pick a mode and watch the … move.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Picker("Truncation Mode", selection: $selectedMode) {
                    Text("Head").tag(TruncationModeOption.head)
                    Text("Tail").tag(TruncationModeOption.tail)
                    Text("Middle").tag(TruncationModeOption.middle)
                }
                .pickerStyle(.segmented)

                Text(sampleText)
                    .lineLimit(1)
                    .truncationMode(selectedMode.mode)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.15))

                Divider()

                Text("All three modes side by side (lineLimit 1):")
                    .font(.headline)

                ForEach(TruncationModeOption.allCases, id: \.self) { option in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(option.label)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(sampleText)
                            .lineLimit(1)
                            .truncationMode(option.mode)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
        }
        .toolbar {
            PlaygroundSourceLink(file: "TruncationModePlayground.swift")
        }
    }
}

/// Wrapper so the picker/list have a `CaseIterable`, labelled value;
/// maps to the real `Text.TruncationMode` applied to each sample.
enum TruncationModeOption: CaseIterable, Hashable {
    case head
    case tail
    case middle

    var mode: Text.TruncationMode {
        switch self {
        case .head: return .head
        case .tail: return .tail
        case .middle: return .middle
        }
    }

    var label: String {
        switch self {
        case .head: return ".head — ellipsis at the start"
        case .tail: return ".tail — ellipsis at the end"
        case .middle: return ".middle — ellipsis in the center"
        }
    }
}
