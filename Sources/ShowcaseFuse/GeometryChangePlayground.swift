// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `onGeometryChange(for:of:action:)`.
///
/// Unlike `GeometryReader` (which reads geometry to *build* its content), `onGeometryChange` reads a
/// view's own geometry and fires a callback whenever the transformed value changes — letting a view
/// report its measured size/frame back out to `@State` without distorting the layout.
///
/// Dragging the slider resizes the boxes, which fires the callbacks and updates the readouts live, so
/// the firing is directly observable. Both overloads are exercised:
///  - the blue box uses the single-value `action: (newValue)` form to mirror its measured size, and
///  - the green box uses the `action: (oldValue, newValue)` form to count changes and show the delta.
struct GeometryChangePlayground: View {
    // NOTE: Skip cannot bridge `private` @State — keep these internal.
    @State var widthFraction: CGFloat = 0.6
    @State var measuredSize: CGSize = .zero
    @State var changeCount = 0
    @State var lastDelta: CGFloat = 0

    // Slider maps to a concrete box width so the resize (and thus the callback) is driven by the user.
    private var blueWidth: CGFloat { 60 + widthFraction * 240 }      // 60…300
    private var greenWidth: CGFloat { 60 + (1 - widthFraction) * 240 } // inverse, so it also changes

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Drag the slider to resize the boxes. Each box reports its own geometry back through `onGeometryChange`.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Slider(value: $widthFraction, in: 0.0...1.0)

                // (newValue) overload — mirror the measured size into a readout.
                VStack(alignment: .leading, spacing: 8) {
                    Text("Measured size: \(Int(measuredSize.width)) × \(Int(measuredSize.height))")
                        .font(.headline)
                        .monospacedDigit()
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: blueWidth, height: 80)
                        .overlay(Text("measure me").font(.caption))
                        .onGeometryChange(for: CGSize.self) { proxy in
                            proxy.size
                        } action: { newSize in
                            measuredSize = newSize
                        }
                }

                Divider()

                // (oldValue, newValue) overload — count changes and report the per-change width delta.
                // This overload is iOS 18+; the single-value form above is iOS 16+.
                VStack(alignment: .leading, spacing: 8) {
                    Text("Width changes: \(changeCount)   (last Δw: \(Int(lastDelta)))")
                        .font(.headline)
                        .monospacedDigit()
                    if #available(iOS 18.0, *) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.green.opacity(0.3))
                            .frame(width: greenWidth, height: 80)
                            .overlay(Text("track my width").font(.caption))
                            .onGeometryChange(for: CGFloat.self) { proxy in
                                proxy.size.width
                            } action: { oldWidth, newWidth in
                                changeCount += 1
                                lastDelta = newWidth - oldWidth
                            }
                    } else {
                        Text("The (oldValue, newValue) overload requires iOS 18+")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .toolbar {
            PlaygroundSourceLink(file: "GeometryChangePlayground.swift")
        }
    }
}
