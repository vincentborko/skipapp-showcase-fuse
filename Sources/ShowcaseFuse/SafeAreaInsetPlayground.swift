// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `View.safeAreaInset(edge:alignment:spacing:content:)`.
///
/// `safeAreaInset` pins a bar at the chosen edge of the view and reserves its space, so the
/// main content fills the remaining area instead of being covered. Pick an edge to move the
/// blue/orange bar; the green content region resizes to fit beside it.
///
/// Note (Android via Skip): the inset content reserves layout space (the common full-bleed
/// bar/banner case). Unlike SwiftUI it does not shrink an enclosing ScrollView's safe area,
/// so scrollable content does not scroll *under* the bar — it is clipped to the area beside it.
struct SafeAreaInsetPlayground: View {
    @State var edge: InsetEdge = .bottom

    enum InsetEdge: String, CaseIterable, Identifiable {
        case top, bottom, leading, trailing
        var id: String { rawValue }
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("safeAreaInset pins a bar at an edge and reserves its space; the green content fills the rest.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            Picker("Edge", selection: $edge) {
                ForEach(InsetEdge.allCases) { edge in
                    Text(edge.rawValue.capitalized).tag(edge)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            liveDemo
                .frame(height: 360)
                .border(.gray)
                .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
        .navigationTitle("SafeAreaInset")
    }

    @ViewBuilder private var liveDemo: some View {
        switch edge {
        case .top:
            contentArea.safeAreaInset(edge: .top) { horizontalBar("TOP BAR") }
        case .bottom:
            contentArea.safeAreaInset(edge: .bottom) { horizontalBar("BOTTOM BAR") }
        case .leading:
            contentArea.safeAreaInset(edge: .leading) { verticalBar("LEAD") }
        case .trailing:
            contentArea.safeAreaInset(edge: .trailing) { verticalBar("TRAIL") }
        }
    }

    private var contentArea: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(0..<14) { i in
                    Text("Content row \(i)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                        .background(Color.green.opacity(0.18))
                }
            }
            .padding(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green.opacity(0.06))
    }

    private func horizontalBar(_ label: String) -> some View {
        Text(label)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.85))
            .foregroundStyle(.white)
    }

    private func verticalBar(_ label: String) -> some View {
        Text(label)
            .font(.caption.bold())
            .frame(maxHeight: .infinity)
            .padding(8)
            .background(Color.orange.opacity(0.9))
            .foregroundStyle(.white)
    }
}
