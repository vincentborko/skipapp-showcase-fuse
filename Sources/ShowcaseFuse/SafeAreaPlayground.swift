// Copyright 2023–2025 Skip
import SwiftUI

#if os(iOS) || os(tvOS) || os(visionOS) || SKIP

enum SafeAreaPlaygroundType: String, CaseIterable {
    case fullscreenContent
    case fullscreenBackground
    case plainList
    case plainListNoNavStack
    case list
    case bottomBar
    case safeAreaInsetBottom
    case safeAreaInsetTop
    case safeAreaInsetLeading
    case safeAreaInsetTrailing
    case safeAreaInsetMultiple

    var title: String {
        switch self {
        case .fullscreenContent:
            return "Ignore safe area"
        case .fullscreenBackground:
            return "Background ignores safe area"
        case .plainList:
            return "Plain list"
        case .plainListNoNavStack:
            return "Plain list outside nav stack"
        case .list:
            return "List"
        case .bottomBar:
            return "Bottom toolbar"
        case .safeAreaInsetBottom:
            return "Safe Area Inset - Bottom"
        case .safeAreaInsetTop:
            return "Safe Area Inset - Top"
        case .safeAreaInsetLeading:
            return "Safe Area Inset - Leading"
        case .safeAreaInsetTrailing:
            return "Safe Area Inset - Trailing"
        case .safeAreaInsetMultiple:
            return "Safe Area Inset - Multiple"
        }
    }

    var coverId: String {
        rawValue + "Cover"
    }

    var sheetId: String {
        rawValue + "Sheet"
    }
}

struct SafeAreaPlayground: View {
    @State var isCoverPresented = false
    @State var isSheetPresented = false
    @State var playgroundType: SafeAreaPlaygroundType = .fullscreenContent

    var body: some View {
        List {
            NavigationLink("Background") {
                SafeAreaBackgroundView()
            }
            Section("Fullscreen cover") {
                ForEach(SafeAreaPlaygroundType.allCases, id: \.coverId) { playgroundType in
                    Button(playgroundType.title) {
                        self.playgroundType = playgroundType
                        isCoverPresented = true
                    }
                }
            }
            Section("Sheet") {
                ForEach(SafeAreaPlaygroundType.allCases, id: \.sheetId) { playgroundType in
                    Button(playgroundType.title) {
                        self.playgroundType = playgroundType
                        isSheetPresented = true
                    }
                }
            }
        }
        #if os(macOS)
        .sheet(isPresented: $isSheetPresented) {
            playground(for: playgroundType)
        }
        #else
        .sheet(isPresented: $isSheetPresented) {
            playground(for: playgroundType)
        }
        .fullScreenCover(isPresented: $isCoverPresented) {
            playground(for: playgroundType)
        }
        #endif
    }

    @ViewBuilder private func playground(for playgroundType: SafeAreaPlaygroundType) -> some View {
        switch playgroundType {
        case .fullscreenContent:
            SafeAreaFullscreenContent()
        case .fullscreenBackground:
            SafeAreaFullscreenBackground()
        case .plainList:
            SafeAreaPlainList()
        case .plainListNoNavStack:
            SafeAreaPlainListNoNavStack()
        case .list:
            SafeAreaList()
        case .bottomBar:
            #if os(macOS)
            SafeAreaList()
            #else
            SafeAreaBottomBar()
            #endif
        case .safeAreaInsetBottom:
            SafeAreaInsetBottomView()
        case .safeAreaInsetTop:
            SafeAreaInsetTopView()
        case .safeAreaInsetLeading:
            SafeAreaInsetLeadingView()
        case .safeAreaInsetTrailing:
            SafeAreaInsetTrailingView()
        case .safeAreaInsetMultiple:
            SafeAreaInsetMultipleView()
        }
    }
}

struct SafeAreaBackgroundView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("Dismiss") {
            dismiss()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.yellow, ignoresSafeAreaEdges: .all)
    }
}

struct SafeAreaFullscreenContent: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.yellow
            Button("Dimiss") {
                dismiss()
            }
        }
        .border(.blue, width: 20.0)
        .ignoresSafeArea()
    }
}

struct SafeAreaFullscreenBackground: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            Button("Dimiss") {
                dismiss()
            }
        }
        .border(.blue, width: 20.0)
    }
}

struct SafeAreaPlainList: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List(0..<40) { index in
                Text("Row: \(index)")
            }
            .listStyle(.plain)
            .navigationTitle(SafeAreaPlaygroundType.plainList.title)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SafeAreaPlainListNoNavStack: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List {
            Button("Dismiss") { dismiss() }
            ForEach(0..<40) { index in
                Text("Row: \(index)")
            }
        }
        .listStyle(.plain)
    }
}

struct SafeAreaList: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List(0..<40) { index in
                Text("Row: \(index)")
            }
            .navigationTitle(SafeAreaPlaygroundType.list.title)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#if os(macOS)
#else
struct SafeAreaBottomBar: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List(0..<40) { index in
                Text("Row: \(index)")
            }
            .navigationTitle(SafeAreaPlaygroundType.bottomBar.title)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
    }
}
#endif

// MARK: - Safe Area Inset Playground Views

struct SafeAreaInsetBottomView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(0..<30, id: \.self) { index in
                        HStack {
                            Circle()
                                .fill(.blue)
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text("Item \(index)")
                                    .font(.headline)
                                Text("This is item number \(index) in the list")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Bottom Inset Demo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Button(action: {}) {
                        Label("Action 1", systemImage: "heart")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Label("Action 2", systemImage: "star")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(.bar, in: .rect(cornerRadius: 12))
                .padding(.horizontal)
            }
        }
    }
}

struct SafeAreaInsetTopView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(0..<30, id: \.self) { index in
                        HStack {
                            Circle()
                                .fill(.green)
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text("Row \(index)")
                                    .font(.headline)
                                Text("Content scrolls beneath the floating top bar")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Top Inset Demo")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                HStack {
                    Image(systemName: "bell.fill")
                        .foregroundColor(.orange)
                    Text("Notification bar - swipe to dismiss")
                        .font(.caption)
                    Spacer()
                    Button("×") {}
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(.yellow.opacity(0.3), in: .rect(cornerRadius: 8))
                .padding(.horizontal)
            }
        }
    }
}

struct SafeAreaInsetLeadingView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(0..<30, id: \.self) { index in
                        HStack {
                            Circle()
                                .fill(.purple)
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text("Content \(index)")
                                    .font(.headline)
                                Text("Content adjusts for leading sidebar")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Leading Inset Demo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .leading, alignment: .center, spacing: 8) {
                VStack(spacing: 12) {
                    ForEach(0..<5) { index in
                        Button(action: {}) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                        .frame(width: 44, height: 44)
                        .background(.purple.opacity(0.1), in: .circle)
                    }
                }
                .padding(.vertical)
                .background(.bar, in: .rect(cornerRadius: 12))
                .padding(.vertical)
            }
        }
    }
}

struct SafeAreaInsetTrailingView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(0..<30, id: \.self) { index in
                        HStack {
                            Circle()
                                .fill(.orange)
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text("Item \(index)")
                                    .font(.headline)
                                Text("Content accounts for trailing floating panel")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Trailing Inset Demo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .trailing) {
                VStack(spacing: 8) {
                    Text("Quick")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.bordered)
                    Button(action: {}) {
                        Image(systemName: "pencil")
                    }
                    .buttonStyle(.bordered)
                    Button(action: {}) {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.bordered)
                    Text("Actions")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(-90))
                }
                .padding()
                .background(.bar, in: .rect(cornerRadius: 12))
                .padding(.vertical)
            }
        }
    }
}

struct SafeAreaInsetMultipleView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(0..<30, id: \.self) { index in
                        HStack {
                            Circle()
                                .fill(.cyan)
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading) {
                                Text("Entry \(index)")
                                    .font(.headline)
                                Text("Multiple safe area insets working together")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Multiple Insets Demo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .top, spacing: 8) {
                Text("🔔 You have 3 new messages")
                    .padding()
                    .background(.blue.opacity(0.2), in: .rect(cornerRadius: 8))
                    .padding(.horizontal)
            }
            .safeAreaInset(edge: .bottom, spacing: 16) {
                HStack {
                    Button("Reply") {}
                        .buttonStyle(.bordered)
                    Button("Archive") {}
                        .buttonStyle(.bordered)
                    Button("Delete") {}
                        .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(.bar, in: .rect(cornerRadius: 12))
                .padding(.horizontal)
            }
        }
    }
}

#else

// macOS stub
struct SafeAreaPlayground: View {
    var body: some View {
        Text("SafeArea features are iOS-specific")
            .padding()
    }
}

#endif
