// Copyright 2023–2025 Skip
import SwiftUI

#if !SKIP
struct CanvasPlayground: View {
    @State var animationPhase: Double = 0.0

    var body: some View {
        #if !SKIP
        // Canvas is temporarily disabled for Skip due to transpilation issues
        ScrollView {
            VStack(spacing: 20) {
                // Basic shapes and paths
                VStack(alignment: .leading, spacing: 10) {
                    Text("Basic Shapes & Paths")
                        .font(.headline)
                    
                    Canvas { context, size in
                        // Draw rectangle
                        let rect = Path(CGRect(x: 10, y: 10, width: 100, height: 60))
                        context.fill(rect, with: .color(.blue))
                        context.stroke(rect, with: .color(.black), lineWidth: 2)
                        
                        // Draw circle
                        let circle = Path(ellipseIn: CGRect(x: 130, y: 10, width: 80, height: 80))
                        context.fill(circle, with: .color(.green))
                        
                        // Draw custom path
                        var triangle = Path()
                        triangle.move(to: CGPoint(x: 250, y: 70))
                        triangle.addLine(to: CGPoint(x: 280, y: 20))
                        triangle.addLine(to: CGPoint(x: 310, y: 70))
                        triangle.closeSubpath()
                        context.fill(triangle, with: .color(.red))
                    }
                    .frame(height: 100)
                    .border(Color.gray)
                }

                // Gradients
                VStack(alignment: .leading, spacing: 10) {
                    Text("Gradients")
                        .font(.headline)
                    
                    Canvas { context, size in
                        let rect = Path(CGRect(x: 0, y: 0, width: size.width, height: size.height))
                        let gradient = Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple])
                        
                        // Linear gradient
                        context.fill(rect, with: .linearGradient(
                            gradient,
                            startPoint: CGPoint(x: 0, y: 0),
                            endPoint: CGPoint(x: size.width, y: 0)
                        ))
                    }
                    .frame(height: 80)
                    .border(Color.gray)
                }

                // Text drawing
                VStack(alignment: .leading, spacing: 10) {
                    Text("Text Drawing")
                        .font(.headline)
                    
                    Canvas { context, size in
                        context.draw(
                            Text("Hello Canvas!")
                                .font(.title)
                                .foregroundColor(.blue),
                            at: CGPoint(x: size.width/2, y: size.height/2),
                            anchor: .center
                        )
                        
                        context.draw(
                            Text("Bottom Left")
                                .font(.caption)
                                .foregroundColor(.red),
                            at: CGPoint(x: 10, y: size.height - 10),
                            anchor: .bottomLeading
                        )
                    }
                    .frame(height: 100)
                    .border(Color.gray)
                }

                // Transforms and opacity
                VStack(alignment: .leading, spacing: 10) {
                    Text("Transforms & Opacity")
                        .font(.headline)
                    
                    Canvas { context, size in
                        var ctx = context
                        
                        // Translate and scale
                        ctx.translateBy(x: size.width/4, y: size.height/2)
                        ctx.scaleBy(x: 1.5, y: 1.5)
                        
                        let circle = Path(ellipseIn: CGRect(x: -30, y: -30, width: 60, height: 60))
                        ctx.opacity = 0.7
                        ctx.fill(circle, with: .color(.orange))
                        
                        // Rotate
                        ctx.rotate(by: .degrees(45))
                        let square = Path(CGRect(x: -15, y: -15, width: 30, height: 30))
                        ctx.opacity = 0.5
                        ctx.fill(square, with: .color(.purple))
                    }
                    .frame(height: 120)
                    .border(Color.gray)
                }

                // Clipping
                VStack(alignment: .leading, spacing: 10) {
                    Text("Clipping")
                        .font(.headline)
                    
                    Canvas { context, size in
                        var ctx = context
                        
                        // Create circular clip
                        let clipCircle = Path(ellipseIn: CGRect(x: size.width/2 - 50, y: size.height/2 - 50, width: 100, height: 100))
                        ctx.clip(to: clipCircle)
                        
                        // Draw something that gets clipped
                        let rect = Path(CGRect(x: 0, y: 0, width: size.width, height: size.height))
                        let gradient = Gradient(colors: [.blue, .purple])
                        ctx.fill(rect, with: .linearGradient(
                            gradient,
                            startPoint: .zero,
                            endPoint: CGPoint(x: size.width, y: size.height)
                        ))
                        
                        // Draw some stripes
                        for i in 0..<10 {
                            let y = CGFloat(i * 15)
                            let stripe = Path()
                            var stripePath = stripe
                            stripePath.move(to: CGPoint(x: 0, y: y))
                            stripePath.addLine(to: CGPoint(x: size.width, y: y))
                            ctx.stroke(stripePath, with: .color(.white), lineWidth: 3)
                        }
                    }
                    .frame(height: 120)
                    .border(Color.gray)
                }

                // Animation example
                VStack(alignment: .leading, spacing: 10) {
                    Text("Animation")
                        .font(.headline)
                    
                    Canvas { context, size in
                        let centerX = size.width / 2
                        let centerY = size.height / 2
                        
                        // Animated rotating circles
                        for i in 0..<8 {
                            let angle = (Double(i) / 8.0 * 2.0 * .pi) + animationPhase
                            let radius = 30.0
                            let x = centerX + cos(angle) * radius
                            let y = centerY + sin(angle) * radius
                            
                            let circle = Path(ellipseIn: CGRect(x: x - 10, y: y - 10, width: 20, height: 20))
                            let color = Color.init(hue: Double(i) / 8.0, saturation: 1.0, brightness: 1.0)
                            context.fill(circle, with: .color(color))
                        }
                    }
                    .frame(height: 120)
                    .border(Color.gray)
                    .onAppear {
                        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                            animationPhase = 2 * .pi
                        }
                    }
                }

                // Blend modes
                VStack(alignment: .leading, spacing: 10) {
                    Text("Blend Modes")
                        .font(.headline)
                    
                    Canvas { context, size in
                        var ctx = context
                        
                        // Base circle
                        let circle1 = Path(ellipseIn: CGRect(x: 30, y: 20, width: 80, height: 80))
                        ctx.fill(circle1, with: .color(.red))
                        
                        // Overlapping circle with multiply blend mode
                        ctx.blendMode = .multiply
                        let circle2 = Path(ellipseIn: CGRect(x: 70, y: 20, width: 80, height: 80))
                        ctx.fill(circle2, with: .color(.blue))
                        
                        // Reset blend mode
                        ctx.blendMode = .normal
                        
                        // Another overlapping circle with screen blend mode
                        ctx.blendMode = .screen
                        let circle3 = Path(ellipseIn: CGRect(x: 170, y: 20, width: 80, height: 80))
                        ctx.fill(circle3, with: .color(.green))
                        
                        let circle4 = Path(ellipseIn: CGRect(x: 210, y: 20, width: 80, height: 80))
                        ctx.fill(circle4, with: .color(.purple))
                    }
                    .frame(height: 120)
                    .border(Color.gray)
                }
                
                Text("Canvas allows for custom 2D drawing with full control over paths, shapes, colors, and effects!")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                PlaygroundSourceLink(file: "CanvasPlayground.swift")
            }
        }
        #else
        // Skip implementation - Canvas not yet supported
        VStack {
            Text("Canvas Drawing")
                .font(.largeTitle)
                .padding()
            Text("Canvas is not yet supported in Skip")
                .foregroundColor(.secondary)
                .padding()
        }
        #endif
    }
}
#else
struct CanvasPlayground: View {
    var body: some View {
        Text("Canvas is not available in Skip")
            .padding()
    }
}
#endif