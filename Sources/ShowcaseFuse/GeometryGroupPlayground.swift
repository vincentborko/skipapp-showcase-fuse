// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `geometryGroup()`.
///
/// `geometryGroup()` asks SwiftUI to resolve a subtree's geometry as a *single unit*: when an ancestor's
/// geometry animates at the same time as a descendant's, the group's frame is computed first and the
/// children are placed within it, instead of every child independently interpolating its own absolute
/// frame (which can make a child appear to take a diagonal/“wrong” path mid-animation).
///
/// Tap **Animate** to simultaneously scale each container *and* offset the inner dot. The two columns are
/// identical except the right one wraps its content in `.geometryGroup()`.
///
/// HONEST NOTE on Android: skip-ui maps `geometryGroup()` onto an identity Compose graphics-layer
/// boundary (the subtree becomes one composited layer, so ancestor transforms apply to it uniformly).
/// This is faithful for the transform-driven case shown here, but it is an *approximation* — Compose
/// re-lays-out every frame rather than interpolating between absolute frames, so the exact SwiftUI
/// artifact that `geometryGroup()` guards against does not arise the same way. The visible difference
/// between the two columns may therefore be subtle on Android; both should animate cleanly.
struct GeometryGroupPlayground: View {
    // NOTE: Skip cannot bridge `private` @State — keep these internal.
    @State var animate = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Tap Animate to scale each container while the inner dot offsets at the same time. The right column groups its geometry with `.geometryGroup()`.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Button(animate ? "Reset" : "Animate") {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        animate.toggle()
                    }
                }
                .buttonStyle(.borderedProminent)

                HStack(alignment: .top, spacing: 32) {
                    VStack(spacing: 8) {
                        Text("Plain").font(.caption).foregroundStyle(.secondary)
                        animatedContainer
                    }
                    VStack(spacing: 8) {
                        Text(".geometryGroup()").font(.caption).foregroundStyle(.secondary)
                        animatedContainer
                            .geometryGroup()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .toolbar {
            PlaygroundSourceLink(file: "GeometryGroupPlayground.swift")
        }
    }

    // A container that scales while its inner dot offsets — the simultaneous ancestor+descendant
    // geometry change that `geometryGroup()` is designed to coordinate.
    private var animatedContainer: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.blue.opacity(0.2))
            .frame(width: 110, height: 110)
            .overlay(
                Circle()
                    .fill(Color.orange)
                    .frame(width: 28, height: 28)
                    .offset(x: animate ? 34 : -34, y: animate ? 34 : -34)
            )
            .scaleEffect(animate ? 1.3 : 0.8)
    }
}
