// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `.symbolEffect(_:...)` on SF Symbols.
///
/// SF Symbols render on Android as a single Material vector (no per-layer access), so the bridge
/// supports the whole-glyph transform/opacity effects, which is what most apps use:
///
/// - `.pulse` (indefinite) — opacity oscillates while `isActive` is true. Toggle it on/off.
/// - `.bounce` (discrete) — a one-shot scale pop each time the `value:` changes. Tap the button.
/// - `.scale` (indefinite) — animates to a held larger/smaller size while `isActive`, back to normal when off.
///
/// These are temporal animations: judge them by running on the emulator.
struct SymbolEffectPlayground: View {
    // internal (not private) so Skip can bridge the @State across to Compose.
    @State var pulseActive = true
    @State var bounceTrigger = 0
    @State var scaleActive = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                Text("symbolEffect animates SF Symbols. The supported effects on Android are the whole-glyph transform/opacity ones.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // .pulse — indefinite opacity oscillation while active.
                VStack(alignment: .leading, spacing: 12) {
                    Text(".pulse — indefinite")
                        .font(.headline)
                    Image(systemName: "wifi")
                        .font(.system(size: 64))
                        .foregroundStyle(.blue)
                        .symbolEffect(.pulse, isActive: pulseActive)
                    Toggle("Pulsing", isOn: $pulseActive)
                    Text("Fades in and out continuously while on; holds steady when off.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Divider()

                // .bounce — discrete one-shot triggered by a value change.
                VStack(alignment: .leading, spacing: 12) {
                    Text(".bounce — discrete (value:)")
                        .font(.headline)
                    Image(systemName: "bell.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.orange)
                        .symbolEffect(.bounce, value: bounceTrigger)
                    Button("Ring (\(bounceTrigger))") { bounceTrigger += 1 }
                        .buttonStyle(.bordered)
                    Text("Pops once each tap — only when the value actually changes, not on first appearance.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Divider()

                // .scale — animate to a held scale while active.
                VStack(alignment: .leading, spacing: 12) {
                    Text(".scale.up — indefinite")
                        .font(.headline)
                    Image(systemName: "star.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.yellow)
                        .symbolEffect(.scale.up, isActive: scaleActive)
                    Toggle("Scaled up", isOn: $scaleActive)
                    Text("Grows to a held larger size while on, animates back to normal when off.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .toolbar {
            PlaygroundSourceLink(file: "SymbolEffectPlayground.swift")
        }
    }
}
