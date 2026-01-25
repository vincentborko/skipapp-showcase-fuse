// Copyright 2023–2025 Skip
import SwiftUI

struct KeyframeAnimatorPlayground: View {
    @State var isAnimating = false
    @State var triggerCount = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("KeyframeAnimator demonstrates keyframe-based animations")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Text("⚠️ Note: KeyframeAnimator has limited implementation due to Skip's WritableKeyPath constraints")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 16) {
                    Text("Basic Keyframe Animation")
                        .font(.title2)
                    
                    Text("Tap to trigger keyframe sequence")
                        .foregroundColor(.secondary)
                    
                    Button("Animate (Count: \(triggerCount))") {
                        triggerCount += 1
                    }
                    .buttonStyle(.borderedProminent)
                    
                    // Note: KeyframeAnimator implementation is currently limited due to WritableKeyPath constraints
                    VStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.yellow)
                            .scaleEffect(triggerCount > 0 ? 1.3 : 1.0)
                            .rotationEffect(.degrees(triggerCount > 0 ? 180 : 0))
                            .animation(.bouncy, value: triggerCount)
                        
                        Text("KeyframeAnimator not fully functional")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                VStack(spacing: 16) {
                    Text("Keyframe Types")
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("LinearKeyframe - Linear interpolation", systemImage: "arrow.right")
                        Label("CubicKeyframe - Cubic bezier curves", systemImage: "curlybraces")
                        Label("SpringKeyframe - Spring-based motion", systemImage: "spring")
                        Label("MoveKeyframe - Instant value changes", systemImage: "bolt")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    
                    Text("These keyframe types are defined but require full KeyPath support for proper implementation")
                        .font(.caption2)
                        .foregroundColor(.orange)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                VStack(spacing: 16) {
                    Text("Conceptual Example")
                        .font(.title2)
                    
                    Text("This shows what KeyframeAnimator would do with full implementation:")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("KeyframeTrack(\\.scale) {").font(.system(.caption, design: .monospaced))
                        Text("  LinearKeyframe(1.5, duration: 0.2)").font(.system(.caption, design: .monospaced))
                        Text("  SpringKeyframe(1.0, spring: .bouncy)").font(.system(.caption, design: .monospaced))
                        Text("}").font(.system(.caption, design: .monospaced))
                        Text("KeyframeTrack(\\.rotation) {").font(.system(.caption, design: .monospaced))
                        Text("  CubicKeyframe(.degrees(360), duration: 0.5)").font(.system(.caption, design: .monospaced))
                        Text("}").font(.system(.caption, design: .monospaced))
                    }
                    .padding(.horizontal)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("KeyframeAnimator")
    }
}

// Simplified animation values struct
struct AnimationValues {
    var scale: CGFloat = 1.0
    var rotation: Angle = .zero
    var yOffset: CGFloat = 0
}

// Placeholder keyframes struct due to Skip limitations
struct EmptyKeyframes {
    // Empty implementation as a placeholder
}

// Preview temporarily disabled due to build issues