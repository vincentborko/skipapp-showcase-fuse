// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `.swipeActions(edge:allowsFullSwipe:content:)` on `List` rows.
///
/// Swipe a row from the trailing edge to reveal Delete + Flag, or from the leading
/// edge to reveal Pin. Tapping a revealed button runs its action (delete removes the
/// row; flag/pin toggle a marker on it) — the "Last action" line and the row markers
/// update so the behavior is observable on the emulator.
///
/// Note on the Android impl: the swipe reveals the buttons and snaps open/closed; you
/// tap a revealed button to act. Unlike SwiftUI, a *full* swipe does not auto-invoke
/// the first action — it just opens fully — because the bridged action view is opaque
/// to the layer that drives the gesture.
struct SwipeActionsPlayground: View {
    // internal (not private) so Skip can bridge the @State across to Compose.
    @State var items: [SwipeItem] = (1...6).map { SwipeItem(id: $0, title: "Item \($0)") }
    @State var lastAction: String = "Swipe a row to reveal its actions"

    var body: some View {
        VStack(spacing: 0) {
            Text(lastAction)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

            List {
                Section("Swipe trailing (Delete/Flag) or leading (Pin)") {
                    ForEach(items) { item in
                        HStack {
                            if item.isPinned {
                                Image(systemName: "pin.fill")
                                    .foregroundStyle(.blue)
                            }
                            Text(item.title)
                            if item.isFlagged {
                                Image(systemName: "flag.fill")
                                    .foregroundStyle(.orange)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                delete(item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button {
                                toggleFlag(item)
                            } label: {
                                Label("Flag", systemImage: "flag")
                            }
                            .tint(.orange)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                togglePin(item)
                            } label: {
                                Label("Pin", systemImage: "pin")
                            }
                            .tint(.blue)
                        }
                    }
                }

                Section("Reset") {
                    Button("Restore all items") {
                        items = (1...6).map { SwipeItem(id: $0, title: "Item \($0)") }
                        lastAction = "Restored all items"
                    }
                }
            }
        }
        .toolbar {
            PlaygroundSourceLink(file: "SwipeActionsPlayground.swift")
        }
    }

    private func delete(_ item: SwipeItem) {
        items.removeAll { $0.id == item.id }
        lastAction = "Deleted \(item.title)"
    }

    private func toggleFlag(_ item: SwipeItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isFlagged.toggle()
            lastAction = "\(items[index].isFlagged ? "Flagged" : "Unflagged") \(item.title)"
        }
    }

    private func togglePin(_ item: SwipeItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isPinned.toggle()
            lastAction = "\(items[index].isPinned ? "Pinned" : "Unpinned") \(item.title)"
        }
    }
}

struct SwipeItem: Identifiable {
    let id: Int
    let title: String
    var isFlagged: Bool = false
    var isPinned: Bool = false
}
