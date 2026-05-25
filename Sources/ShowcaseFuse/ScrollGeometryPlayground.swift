// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `onScrollGeometryChange(for:of:action:)`.
///
/// The header reacts to the scroll offset the same way the app's Home screen does: it collapses and
/// gains a background once you've scrolled past a threshold (a sticky-header `isScrolled` state), and
/// shows the live `ScrollGeometry` values so the callback is visibly firing.
struct ScrollGeometryPlayground: View {
    // NOTE: Skip cannot bridge `private` @State — keep these internal.
    @State var offsetY: CGFloat = 0
    @State var isScrolled = false
    @State var containerHeight: CGFloat = 0
    @State var contentHeight: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Scroll Geometry")
                    .font(isScrolled ? .headline : .largeTitle)
                Text("offsetY \(Int(offsetY))  •  container \(Int(containerHeight))  •  content \(Int(contentHeight))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(isScrolled ? Color.blue.opacity(0.18) : Color.clear)
            .animation(.easeInOut(duration: 0.2), value: isScrolled)

            if #available(iOS 18.0, *) {
                rows
                    .onScrollGeometryChange(for: ScrollGeometry.self, of: { $0 }) { _, geometry in
                        offsetY = geometry.contentOffset.y
                        isScrolled = geometry.contentOffset.y > 24
                        containerHeight = geometry.containerSize.height
                        contentHeight = geometry.contentSize.height
                    }
            } else {
                rows
                Text("onScrollGeometryChange requires iOS 18+")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .toolbar {
            PlaygroundSourceLink(file: "ScrollGeometryPlayground.swift")
        }
    }

    private var rows: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(0..<40) { i in
                    Text("Row \(i)")
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}
