import SwiftUI

// Helper modifier to apply scroll target behavior conditionally
struct ScrollBehaviorModifier: ViewModifier {
    let isPaging: Bool
    let isViewAligned: Bool
    
    func body(content: Content) -> some View {
        #if !SKIP
        if isPaging {
            content.scrollTargetBehavior(.paging)
        } else if isViewAligned {
            content.scrollTargetBehavior(.viewAligned)
        } else {
            content
        }
        #else
        content
        #endif
    }
}

struct ScrollPositionPlayground: View {
    @State var scrolledID: Int? = nil
    @State var targetID: Int? = nil
    @State var isPagingEnabled = false
    @State var isViewAlignedEnabled = false
    
    let items = Array(1...50)
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                // Controls
                VStack(spacing: 10) {
                    HStack {
                        Text("Current ID: \(scrolledID?.description ?? "None")")
                            .font(.caption)
                        Spacer()
                        Text("Target ID:")
                            .font(.caption)
                        TextField("ID", value: $targetID, format: .number)
                            .frame(width: 50)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit {
                                if let target = targetID {
                                    scrolledID = target
                                }
                            }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Toggle("View Aligned", isOn: $isViewAlignedEnabled)
                            .font(.caption)
                        Toggle("Paging", isOn: $isPagingEnabled)
                            .font(.caption)
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 10) {
                        Button("Top") {
                            scrolledID = items.first
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Middle") {
                            scrolledID = items[items.count / 2]
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Bottom") {
                            scrolledID = items.last
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Random") {
                            scrolledID = items.randomElement()
                        }
                        .buttonStyle(.bordered)
                    }
                    .font(.caption)
                }
                .padding(.vertical, 10)
                
                Divider()
                
                // Vertical scroll example
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(items, id: \.self) { item in
                            ItemView(item: item, color: colors[item % colors.count])
                                .id(item)
                        }
                    }
                    #if !SKIP
                    .scrollTargetLayout()
                    #endif
                }
                #if !SKIP
                .scrollPosition(id: $scrolledID)
                #endif
                .modifier(ScrollBehaviorModifier(isPaging: isPagingEnabled, isViewAligned: isViewAlignedEnabled))
                
                Divider()
                
                // Horizontal scroll example
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(items.prefix(20), id: \.self) { item in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(colors[item % colors.count].gradient)
                                .frame(width: 80, height: 80)
                                .overlay {
                                    Text("\(item)")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                }
                                .id(item)
                        }
                    }
                    #if !SKIP
                    .scrollTargetLayout()
                    #endif
                    .padding()
                }
                #if !SKIP
                .scrollPosition(id: $scrolledID)
                #endif
                .modifier(ScrollBehaviorModifier(isPaging: isPagingEnabled, isViewAligned: isViewAlignedEnabled))
                .frame(height: 120)
            }
            .navigationTitle("Scroll Position")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    PlaygroundSourceLink(file: "ScrollPositionPlayground.swift")
                }
            }
        }
    }
    
    struct ItemView: View {
        let item: Int
        let color: Color
        
        var body: some View {
            RoundedRectangle(cornerRadius: 10)
                .fill(color.gradient)
                .frame(height: 60)
                .overlay {
                    HStack {
                        Text("Item \(item)")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .padding()
                }
                .padding(.horizontal)
        }
    }
}