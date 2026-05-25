// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `.textSelection(_:)`, which makes the text in a subtree
/// user-selectable so it can be copied or shared.
///
/// On Android this maps to Compose's `SelectionContainer` (for `.enabled`) and
/// `DisableSelection` (for `.disabled`, to opt a region out of an enclosing
/// selectable container). Selection is interactive — long-press the enabled
/// text below to see the selection handles and a copy menu appear.
struct TextSelectionPlayground: View {
    private let sample = "Long-press this text to select and copy it. The quick brown fox jumps over the lazy dog."

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("textSelection makes text selectable for copy/share. Long-press the enabled samples to bring up selection handles.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                section(title: ".textSelection(.enabled) — selectable") {
                    Text(sample)
                        .textSelection(.enabled)
                }

                section(title: ".textSelection(.disabled) — default, not selectable") {
                    Text(sample)
                        .textSelection(.disabled)
                }

                Divider()

                Text("Applied to a whole subtree: the VStack below is .enabled, but the middle row opts back out with .disabled.")
                    .font(.headline)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Selectable row one — phone: 555-0142")
                    Text("NOT selectable (this row carries .disabled)")
                        .textSelection(.disabled)
                        .foregroundStyle(.secondary)
                    Text("Selectable row three — email: hello@example.com")
                }
                .textSelection(.enabled)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.15))
            }
            .padding()
        }
        .toolbar {
            PlaygroundSourceLink(file: "TextSelectionPlayground.swift")
        }
    }

    @ViewBuilder private func section(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            content()
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.15))
        }
    }
}
