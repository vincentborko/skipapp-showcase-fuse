import SwiftUI

struct AdvancedGesturesPlayground: View {
    // Pinch to zoom state
    @State var scale: CGFloat = 1.0
    @State var lastScale: CGFloat = 1.0
    
    // Two-finger rotation state  
    @State var rotation: Angle = .zero
    @State var lastRotation: Angle = .zero
    
    // Combined gesture state
    @State var combinedScale: CGFloat = 1.0
    @State var lastCombinedScale: CGFloat = 1.0
    @State var combinedRotation: Angle = .zero
    @State var lastCombinedRotation: Angle = .zero
    
    // Drag with velocity state
    @State var dragOffset: CGSize = .zero
    @State var isDragging = false
    @State var dragVelocity: CGSize = .zero
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Advanced Gestures")
                    .font(.largeTitle)
                    .padding()
                
                // MARK: - Pinch to Zoom
                VStack {
                    Text("Pinch to Zoom")
                        .font(.headline)
                    
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .scaleEffect(scale)
                        .gesture(
                            MagnifyGesture()
                                .onChanged { value in
                                    scale = lastScale * value.magnification
                                }
                                .onEnded { value in
                                    lastScale = scale
                                }
                        )
                        .overlay(
                            Text("Scale: \(scale, specifier: "%.2f")")
                                .padding(8)
                                .background(Color.black.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(8),
                            alignment: .topTrailing
                        )
                    
                    Button("Reset") {
                        withAnimation {
                            scale = 1.0
                            lastScale = 1.0
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // MARK: - Two-finger Rotation
                VStack {
                    Text("Two-finger Rotation")
                        .font(.headline)
                    
                    Image(systemName: "dial.high")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .rotationEffect(rotation)
                        .gesture(
                            RotateGesture()
                                .onChanged { value in
                                    rotation = lastRotation + value.rotation
                                }
                                .onEnded { value in
                                    lastRotation = rotation
                                }
                        )
                        .overlay(
                            Text("Angle: \(rotation.degrees, specifier: "%.0f")°")
                                .padding(8)
                                .background(Color.black.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(8),
                            alignment: .topTrailing
                        )
                    
                    Button("Reset") {
                        withAnimation {
                            rotation = .zero
                            lastRotation = .zero
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // MARK: - Combined Zoom + Rotate
                VStack {
                    Text("Combined: Zoom + Rotate")
                        .font(.headline)
                    
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .foregroundColor(.yellow)
                        .scaleEffect(combinedScale)
                        .rotationEffect(combinedRotation)
                        .gesture(
                            MagnifyGesture()
                                .simultaneously(with: RotateGesture())
                                .onChanged { value in
                                    if let magnify = value.first {
                                        combinedScale = lastCombinedScale * magnify.magnification
                                    }
                                    if let rotate = value.second {
                                        combinedRotation = lastCombinedRotation + rotate.rotation
                                    }
                                }
                                .onEnded { value in
                                    lastCombinedScale = combinedScale
                                    lastCombinedRotation = combinedRotation
                                }
                        )
                        .overlay(
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Scale: \(combinedScale, specifier: "%.2f")")
                                Text("Angle: \(combinedRotation.degrees, specifier: "%.0f")°")
                            }
                            .padding(8)
                            .background(Color.black.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(8),
                            alignment: .topTrailing
                        )
                    
                    Button("Reset") {
                        withAnimation {
                            combinedScale = 1.0
                            lastCombinedScale = 1.0
                            combinedRotation = .zero
                            lastCombinedRotation = .zero
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // MARK: - Drag with Velocity
                VStack {
                    Text("Drag with Velocity")
                        .font(.headline)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 300, height: 200)
                        
                        Circle()
                            .fill(isDragging ? Color.orange : Color.blue)
                            .frame(width: 50, height: 50)
                            .offset(dragOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                        dragVelocity = value.velocity
                                        isDragging = true
                                    }
                                    .onEnded { value in
                                        isDragging = false
                                        // Could add physics-based animation using velocity
                                        withAnimation(.spring()) {
                                            dragOffset = .zero
                                        }
                                    }
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Offset: (\(dragOffset.width, specifier: "%.1f"), \(dragOffset.height, specifier: "%.1f"))")
                        Text("Velocity: (\(dragVelocity.width, specifier: "%.1f"), \(dragVelocity.height, specifier: "%.1f")) pts/sec")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // MARK: - Legacy Names
                VStack {
                    Text("Legacy Gesture Names")
                        .font(.headline)
                    
                    Text("The following type aliases are available for iOS 16 and earlier compatibility:")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("MagnificationGesture")
                                .font(.system(.body, design: .monospaced))
                            Text("→")
                            Text("MagnifyGesture")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.blue)
                        }
                        
                        HStack {
                            Text("RotationGesture")
                                .font(.system(.body, design: .monospaced))
                            Text("→")
                            Text("RotateGesture")
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Advanced Gestures")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct AdvancedGesturesPlayground_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AdvancedGesturesPlayground()
        }
    }
}