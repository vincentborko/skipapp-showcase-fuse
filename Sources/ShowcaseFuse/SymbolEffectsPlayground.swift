// Copyright 2023–2025 Skip
import SwiftUI

struct SymbolEffectsPlayground: View {
    @State var isBouncing = false
    @State var isPulsing = false
    @State var isColorVariating = false
    @State var isBreathing = false
    @State var isRotating = false
    @State var isWiggling = false
    @State var likeCount = 0
    @State var scaleCount = 0
    @State var replaceIcon = false
    @State var appearIcon = true
    @State var disappearIcon = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Indefinite Effects Section
                GroupBox("Indefinite Effects") {
                    VStack(spacing: 20) {
                        // Bounce Effect
                        HStack {
                            Image(systemName: "bell.fill")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                                .symbolEffect(.bounce, isActive: isBouncing)
                            
                            Spacer()
                            
                            Toggle("Bounce", isOn: $isBouncing)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Pulse Effect
                        HStack {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                                .symbolEffect(.pulse, isActive: isPulsing)
                            
                            Spacer()
                            
                            Toggle("Pulse", isOn: $isPulsing)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Variable Color Effect
                        HStack {
                            Image(systemName: "wifi")
                                .font(.largeTitle)
                                .symbolEffect(.variableColor, isActive: isColorVariating)
                            
                            Spacer()
                            
                            Toggle("Variable Color", isOn: $isColorVariating)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Breathe Effect
                        HStack {
                            Image(systemName: "moon.stars.fill")
                                .font(.largeTitle)
                                .foregroundColor(.purple)
                                .symbolEffect(.breathe, isActive: isBreathing)
                            
                            Spacer()
                            
                            Toggle("Breathe", isOn: $isBreathing)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Rotate Effect
                        HStack {
                            Image(systemName: "gear")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                                .symbolEffect(.rotate, isActive: isRotating)
                            
                            Spacer()
                            
                            Toggle("Rotate", isOn: $isRotating)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Wiggle Effect
                        HStack {
                            Image(systemName: "bell.badge.fill")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                                .symbolEffect(.wiggle, isActive: isWiggling)
                            
                            Spacer()
                            
                            Toggle("Wiggle", isOn: $isWiggling)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                
                // Discrete Effects Section
                GroupBox("Discrete Effects") {
                    VStack(spacing: 20) {
                        // Bounce on Value Change
                        HStack {
                            Image(systemName: "heart.fill")
                                .font(.largeTitle)
                                .foregroundColor(.pink)
                                .symbolEffect(.bounce, value: likeCount)
                            
                            Spacer()
                            
                            Button("Like") {
                                likeCount += 1
                            }
                            .buttonStyle(.borderedProminent)
                            
                            Text("\(likeCount)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Scale Effect
                        HStack {
                            Image(systemName: "star.fill")
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                                .symbolEffect(.scale.up, value: scaleCount)
                            
                            Spacer()
                            
                            Button("Scale") {
                                scaleCount += 1
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Replace Effect
                        HStack {
                            Image(systemName: replaceIcon ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                .font(.largeTitle)
                                .foregroundColor(.indigo)
                                .symbolEffect(.replace, value: replaceIcon)
                            
                            Spacer()
                            
                            Button("Toggle Sound") {
                                replaceIcon.toggle()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Appear Effect
                        HStack {
                            if appearIcon {
                                Image(systemName: "sun.max.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.orange)
                                    .symbolEffect(.appear, isActive: appearIcon)
                            } else {
                                Color.clear
                                    .frame(width: 40, height: 40)
                            }
                            
                            Spacer()
                            
                            Button("Toggle Appear") {
                                appearIcon.toggle()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Disappear Effect
                        HStack {
                            Image(systemName: "moon.fill")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                                .symbolEffect(.disappear, isActive: disappearIcon)
                            
                            Spacer()
                            
                            Button("Disappear") {
                                disappearIcon.toggle()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                
                // Options Demo Section
                GroupBox("Effect Options") {
                    VStack(spacing: 20) {
                        // Speed Option
                        HStack {
                            Image(systemName: "hare.fill")
                                .font(.largeTitle)
                                .foregroundColor(.brown)
                                .symbolEffect(.bounce, options: .speed(2.0), isActive: true)
                            
                            Text("Fast (2x speed)")
                                .font(.caption)
                            
                            Spacer()
                            
                            Image(systemName: "tortoise.fill")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                                .symbolEffect(.bounce, options: .speed(0.5), isActive: true)
                            
                            Text("Slow (0.5x speed)")
                                .font(.caption)
                        }
                        .padding(.horizontal)
                        
                        Divider()
                        
                        // Repeat Count Option
                        HStack {
                            Image(systemName: "repeat.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.purple)
                                .symbolEffect(.bounce, options: .repeat(3), value: Date().timeIntervalSince1970)
                            
                            Text("Repeats 3 times")
                                .font(.caption)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Symbol Effects")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        SymbolEffectsPlayground()
    }
}