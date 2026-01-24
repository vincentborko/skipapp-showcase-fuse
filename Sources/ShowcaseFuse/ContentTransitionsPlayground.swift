// Copyright 2023–2025 Skip
import SwiftUI

struct ContentTransitionsPlayground: View {
    @State private var count = 0
    @State private var isToggled = false
    @State private var favoriteFruit = "Apple"
    @State private var score = 50
    
    private let fruits = ["Apple", "Banana", "Cherry", "Dragonfruit", "Elderberry"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Identity - No Animation
                VStack(alignment: .leading, spacing: 8) {
                    Text("Identity Transition")
                        .font(.headline)
                    Text("No animation - content changes instantly")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Button("Toggle") {
                            withAnimation(.default) {
                                isToggled.toggle()
                            }
                        }
                        Spacer()
                        Text(isToggled ? "ON" : "OFF")
                            .contentTransition(.identity)
                            .font(.title2)
                            .bold()
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Opacity Transition
                VStack(alignment: .leading, spacing: 8) {
                    Text("Opacity Transition")
                        .font(.headline)
                    Text("Content fades in and out")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Button("Next Fruit") {
                            withAnimation(.default) {
                                let currentIndex = fruits.firstIndex(of: favoriteFruit) ?? 0
                                let nextIndex = (currentIndex + 1) % fruits.count
                                favoriteFruit = fruits[nextIndex]
                            }
                        }
                        Spacer()
                        Text(favoriteFruit)
                            .contentTransition(.opacity)
                            .font(.title2)
                            .bold()
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Interpolate Transition
                VStack(alignment: .leading, spacing: 8) {
                    Text("Interpolate Transition")
                        .font(.headline)
                    Text("Smooth morphing between text")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Button("Toggle Text") {
                            withAnimation(.default) {
                                isToggled.toggle()
                            }
                        }
                        Spacer()
                        Text(isToggled ? "Show Less" : "Show More")
                            .contentTransition(.interpolate)
                            .font(.title2)
                            .bold()
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Numeric Text Transition
                VStack(alignment: .leading, spacing: 8) {
                    Text("Numeric Text Transition")
                        .font(.headline)
                    Text("Digits animate up/down based on value changes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Button("-10") {
                                withAnimation(.default) {
                                    count = max(0, count - 10)
                                }
                            }
                            Button("-1") {
                                withAnimation(.default) {
                                    count = max(0, count - 1)
                                }
                            }
                            Spacer()
                            Text("\\(count)")
                                .contentTransition(.numericText())
                                .font(.largeTitle)
                                .bold()
                                .monospacedDigit()
                            Spacer()
                            Button("+1") {
                                withAnimation(.default) {
                                    count += 1
                                }
                            }
                            Button("+10") {
                                withAnimation(.default) {
                                    count += 10
                                }
                            }
                        }
                        
                        // Score with countdown behavior
                        HStack {
                            Button("Random Score") {
                                withAnimation(.default) {
                                    score = Int.random(in: 0...100)
                                }
                            }
                            Spacer()
                            Text("Score: \\(score)")
                                .contentTransition(.numericText(countsDown: false))
                                .font(.title2)
                                .bold()
                                .monospacedDigit()
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Combined Example - Counter with Label
                VStack(alignment: .leading, spacing: 8) {
                    Text("Combined Example")
                        .font(.headline)
                    Text("Number with interpolating label")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 12) {
                        Text("\\(count)")
                            .contentTransition(.numericText())
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .monospacedDigit()
                        
                        Text(count == 0 ? "Zero" : count == 1 ? "One" : count < 10 ? "Single Digit" : count < 100 ? "Double Digit" : "Triple Digit")
                            .contentTransition(.interpolate)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Button("Reset") {
                            withAnimation(.default) {
                                count = 0
                            }
                        }
                        Button("Random") {
                            withAnimation(.default) {
                                count = Int.random(in: 0...999)
                            }
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Content Transitions")
        .toolbar {
            PlaygroundSourceLink(file: "ContentTransitionsPlayground.swift")
        }
    }
}

#Preview {
    NavigationView {
        ContentTransitionsPlayground()
    }
}