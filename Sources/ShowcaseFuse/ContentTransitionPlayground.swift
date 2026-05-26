// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `.contentTransition(_:)`, which animates how a view's *content*
/// changes — but only when that change happens inside `withAnimation`.
///
/// - `.numericText()` rolls digits vertically (a counter feel).
/// - `.opacity` / `.interpolate` crossfade between the old and new content.
///
/// The last section is a control: the same `.numericText()` modifier on a value
/// changed *without* `withAnimation`, which should swap instantly with no roll —
/// proving the transition is gated on an active animation, as in SwiftUI.
struct ContentTransitionPlayground: View {
    // internal (not private) so Skip can bridge the @State across to Compose.
    @State var count = 0
    @State var price = 9.99
    @State var greeting = "Hello"
    @State var instantCount = 0

    private let greetings = ["Hello", "Bonjour", "Hola", "Ciao", "Hallo"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                Text("contentTransition animates content changes made inside withAnimation. Tap the buttons and watch how each value updates.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // .numericText() — digit roll on an integer counter.
                VStack(alignment: .leading, spacing: 8) {
                    Text(".numericText() — counter")
                        .font(.headline)
                    Text("\(count)")
                        .font(.system(size: 56, weight: .bold))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                    HStack(spacing: 8) {
                        Button("−10") { withAnimation { count -= 10 } }
                        Button("−1") { withAnimation { count -= 1 } }
                        Button("+1") { withAnimation { count += 1 } }
                        Button("+10") { withAnimation { count += 10 } }
                    }
                    .buttonStyle(.bordered)
                }

                Divider()

                // .numericText(value:) — a formatted currency string.
                VStack(alignment: .leading, spacing: 8) {
                    Text(".numericText() — currency")
                        .font(.headline)
                    Text(verbatim: String(format: "$%.2f", price))
                        .font(.title)
                        .monospacedDigit()
                        .contentTransition(.numericText(value: price))
                    HStack(spacing: 8) {
                        Button("−$5") { withAnimation { price = max(0, price - 5) } }
                        Button("+$5") { withAnimation { price += 5 } }
                    }
                    .buttonStyle(.bordered)
                }

                Divider()

                // .opacity — crossfade between unrelated strings.
                VStack(alignment: .leading, spacing: 8) {
                    Text(".opacity — crossfade")
                        .font(.headline)
                    Text(greeting)
                        .font(.title)
                        .contentTransition(.opacity)
                    Button("Next greeting") {
                        withAnimation {
                            let idx = greetings.firstIndex(of: greeting) ?? 0
                            greeting = greetings[(idx + 1) % greetings.count]
                        }
                    }
                    .buttonStyle(.bordered)
                }

                Divider()

                // Control: same modifier, but the change is NOT wrapped in withAnimation,
                // so it should swap instantly (no roll) — the visual proof of gating.
                VStack(alignment: .leading, spacing: 8) {
                    Text("Control — no withAnimation")
                        .font(.headline)
                    Text("\(instantCount)")
                        .font(.system(size: 40, weight: .bold))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                    Button("+1 (instant)") { instantCount += 1 }
                        .buttonStyle(.bordered)
                    Text("Plain assignment: should jump with no roll, unlike the animated counter above.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .toolbar {
            PlaygroundSourceLink(file: "ContentTransitionPlayground.swift")
        }
    }
}
