// Copyright 2023–2025 Skip
import SwiftUI

struct PhaseAnimatorPlayground: View {
    @State var isTriggered = false
    @State var triggerCount = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("PhaseAnimator demonstrates multi-phase animations")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Text("⚠️ Note: PhaseAnimator bridging is currently limited - showing simplified examples")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(spacing: 16) {
                    Text("Continuous Phase Animation")
                        .font(.title2)
                    
                    Text("This animation continuously cycles through phases")
                        .foregroundColor(.secondary)
                    
                    // PhaseAnimator bridging is complex - showing simple placeholder
                    Circle()
                        .fill(.blue)
                        .scaleEffect(1.0)
                        .frame(width: 60, height: 60)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                VStack(spacing: 16) {
                    Text("Triggered Phase Animation")
                        .font(.title2)
                    
                    Text("Tap the button to trigger a multi-phase animation sequence")
                        .foregroundColor(.secondary)
                    
                    Button("Trigger Animation (Count: \(triggerCount))") {
                        triggerCount += 1
                    }
                    .buttonStyle(.borderedProminent)
                    
                    // Note: PhaseAnimator bridging is limited currently
                    // PhaseAnimator bridging is complex - showing simple placeholder
                    let currentPhase = AnimationPhase.allCases[triggerCount % AnimationPhase.allCases.count]
                    RoundedRectangle(cornerRadius: 12)
                        .fill(currentPhase.color)
                        .frame(width: 80, height: 80)
                        .offset(x: currentPhase.offsetX, y: currentPhase.offsetY)
                        .scaleEffect(currentPhase.scale)
                        .opacity(currentPhase.opacity)
                        .animation(currentPhase.animation, value: triggerCount)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                VStack(spacing: 16) {
                    Text("Heart Pulse Animation")
                        .font(.title2)
                    
                    Text("A classic phase animation example")
                        .foregroundColor(.secondary)
                    
                    // PhaseAnimator bridging is complex - showing simple placeholder
                    Image(systemName: "heart.fill")
                        .font(.system(size: 50))
                        .scaleEffect(1.0)
                        .foregroundStyle(.pink)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                #if !SKIP
                Text("Note: PhaseAnimator bridging is limited in this build")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                #endif
            }
            .padding()
        }
        .navigationTitle("PhaseAnimator")
    }
}

// Custom phase enum for the triggered animation example
enum AnimationPhase: CaseIterable, Equatable {
    case initial, middle, final
    
    var color: Color {
        switch self {
        case .initial: return .blue
        case .middle: return .green  
        case .final: return .purple
        }
    }
    
    var offsetX: CGFloat {
        switch self {
        case .initial: return -50
        case .middle: return 0
        case .final: return 50
        }
    }
    
    var offsetY: CGFloat {
        switch self {
        case .initial: return 0
        case .middle: return -30
        case .final: return 0
        }
    }
    
    var scale: CGFloat {
        switch self {
        case .initial: return 1.0
        case .middle: return 1.5
        case .final: return 1.0
        }
    }
    
    var opacity: Double {
        switch self {
        case .initial: return 1.0
        case .middle: return 0.8
        case .final: return 1.0
        }
    }
    
    var animation: Animation {
        switch self {
        case .initial: return .easeOut(duration: 0.3)
        case .middle: return .spring(response: 0.6, dampingFraction: 0.8)
        case .final: return .easeIn(duration: 0.4)
        }
    }
}

// Preview temporarily disabled due to build issues