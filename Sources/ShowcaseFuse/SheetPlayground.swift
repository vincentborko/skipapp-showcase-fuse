// Copyright 2023–2025 Skip
import SwiftUI

struct SheetPlayground: View {
    struct Item: Identifiable {
        var id: Int
    }

    @State var isSheetPresented = false
    @State var isSimpleSheetPresented = false
    @State var isDetentSheetPresented = false
    @State var isPresentationModifiersSheetPresented = false
    @State var isFullScreenPresented = false
    @State var isSimpleFullScreenPresented = false
    @State var item: Item? = nil
    @State var itemID = 0

    var body: some View {
        #if os(macOS)
        VStack(spacing: 16) {
            Button("Present sheet with navigation stack") {
                isSheetPresented = true
            }
            Button("Present sheet with simple content") {
                isSimpleSheetPresented = true
            }
        }
        .sheet(isPresented: $isSheetPresented, onDismiss: { logger.info("onDismiss called") }) {
            SheetContentView(dismissSheet: { isSheetPresented = false })
        }
        .sheet(isPresented: $isSimpleSheetPresented, onDismiss: { logger.info("onDismiss called") }) {
            Button("Tap to dismiss") {
                isSimpleSheetPresented = false
            }

        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                PlaygroundSourceLink(file: "SheetPlayground.swift")
            }
        }
        #else
        VStack(spacing: 16) {
            Button("Present sheet with navigation stack") {
                isSheetPresented = true
            }
            Button("Present sheet with simple content") {
                isSimpleSheetPresented = true
            }
            Button("Present sheet with medium detent") {
                isDetentSheetPresented = true
            }
            Button("Present sheet with presentation modifiers") {
                isPresentationModifiersSheetPresented = true
            }
            Button("Present item sheet: \(itemID + 1)") {
                itemID += 1
                item = Item(id: itemID)
            }
            Button("Present full screen cover with navigation stack") {
                isFullScreenPresented = true
            }
            Button("Present full screen cover with simple content") {
                isSimpleFullScreenPresented = true
            }
        }
        .sheet(isPresented: $isSheetPresented, onDismiss: { logger.info("onDismiss called") }) {
            SheetContentView(dismissSheet: { isSheetPresented = false })
        }
        .sheet(isPresented: $isSimpleSheetPresented, onDismiss: { logger.info("onDismiss called") }) {
            Button("Back button is disabled. Tap to dismiss") {
                isSimpleSheetPresented = false
            }
            #if os(Android)
            .backDismissDisabled()
            #endif
        }
        .sheet(item: $item, onDismiss: { logger.info("onDismiss called") }) { value in
            VStack(spacing: 16) {
                Text("Value: \(value.id)")
                Button("Tap to dismiss") {
                    item = nil
                }
            }
        }
        .sheet(isPresented: $isDetentSheetPresented, content: {
            Button("Tap to dismiss") {
                isDetentSheetPresented = false
            }
            .presentationDetents([.medium])
        })
        .sheet(isPresented: $isPresentationModifiersSheetPresented, content: {
            PresentationModifiersSheetContent {
                isPresentationModifiersSheetPresented = false
            }
        })
        .fullScreenCover(isPresented: $isFullScreenPresented) {
            SheetContentView(dismissSheet: { isFullScreenPresented = false })
        }
        .fullScreenCover(isPresented: $isSimpleFullScreenPresented) {
            Button("Back button is disabled. Tap to dismiss") {
                isSimpleFullScreenPresented = false
            }
            #if os(Android)
            .backDismissDisabled()
            #endif
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                PlaygroundSourceLink(file: "SheetPlayground.swift")
            }
        }
        #endif
    }
}

struct SheetContentView: View {
    @State var isPresented = false
    @State var counter = 0
    @State var text = ""
    @State var interactiveDismissDisabled = false
    @Environment(\.dismiss) var dismiss
    let dismissSheet: () -> Void

    var body: some View {
        NavigationStack {
            List {
                TextField("Text", text: $text)
                Button("Present another") {
                    isPresented = true
                }
                Button("Dismiss via state") {
                    dismissSheet()
                }
                Button("Dismiss via environment") {
                    dismiss()
                }
                Button("Increment counter: \(counter)") {
                    counter += 1
                }
                Button("Interactive dismiss: \(interactiveDismissDisabled ? "disabled" : "enabled")") {
                    interactiveDismissDisabled = !interactiveDismissDisabled
                }
                ForEach(0..<40) { index in
                    Text("Content row \(index)")
                }
            }
            .interactiveDismissDisabled(interactiveDismissDisabled)
            .navigationTitle("Sheet")
        }
        .sheet(isPresented: $isPresented) {
            SheetContentView(dismissSheet: { isPresented = false })
        }
    }
}

struct PresentationModifiersSheetContent: View {
    @State var selectedDetent: DetentOption = .fraction75
    @State var dragIndicatorVisible = true
    @State var customCornerRadius: CGFloat = 16.0
    @State var useCustomCornerRadius = false
    let dismissSheet: () -> Void

    enum DetentOption: String, CaseIterable {
        case medium = "Medium"
        case large = "Large" 
        case fraction75 = "75% Fraction"
        case height300 = "300pt Height"
        
        var presentationDetent: PresentationDetent {
            switch self {
            case .medium: return .medium
            case .large: return .large
            case .fraction75: return .fraction(0.75)
            case .height300: return .height(300)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Presentation Detents") {
                    Picker("Detent", selection: $selectedDetent) {
                        ForEach(DetentOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Drag Indicator") {
                    Toggle("Show Drag Indicator", isOn: $dragIndicatorVisible)
                }
                
                Section("Corner Radius") {
                    Toggle("Use Custom Corner Radius", isOn: $useCustomCornerRadius)
                    if useCustomCornerRadius {
                        VStack {
                            HStack {
                                Text("Corner Radius: \(Int(customCornerRadius))pt")
                                Spacer()
                            }
                            Slider(value: $customCornerRadius, in: 0...50, step: 1)
                        }
                    }
                }
                
                Section("Actions") {
                    Button("Dismiss Sheet") {
                        dismissSheet()
                    }
                }
                
                ForEach(1...20, id: \.self) { index in
                    Text("Content Row \(index)")
                        .padding(.vertical, 4)
                }
            }
            .navigationTitle("Presentation Modifiers")
            #if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
        .presentationDetents([selectedDetent.presentationDetent])
        #if !SKIP
        .presentationDragIndicator(dragIndicatorVisible ? .visible : .hidden)
        .presentationCornerRadius(useCustomCornerRadius ? customCornerRadius : nil)
        #endif
    }
}

