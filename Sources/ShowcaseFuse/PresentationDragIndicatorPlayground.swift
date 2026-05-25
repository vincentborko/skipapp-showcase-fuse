// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `.presentationDragIndicator(_:)`, which shows or hides the grabber
/// at the top of a presented sheet.
///
/// skip-ui draws a grabber by default on partial-height sheets, so the observable
/// behavior here is toggling it off with `.hidden` (and forcing it with `.visible`).
/// Present each sheet and compare the top edge: the `.hidden` sheet has no grabber.
struct PresentationDragIndicatorPlayground: View {
    // internal (not private) so Skip can bridge the @State across to Compose.
    @State var isVisiblePresented = false
    @State var isHiddenPresented = false
    @State var isAutomaticPresented = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("presentationDragIndicator controls the grabber at the top of a sheet. Present each variant and look at the sheet's top edge.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("Present sheet — .visible (grabber shown)") {
                    isVisiblePresented = true
                }
                Button("Present sheet — .hidden (no grabber)") {
                    isHiddenPresented = true
                }
                Button("Present sheet — .automatic (default)") {
                    isAutomaticPresented = true
                }
            }
            .padding()
        }
        .sheet(isPresented: $isVisiblePresented) {
            DragIndicatorSheet(label: ".visible — grabber should be shown") {
                isVisiblePresented = false
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isHiddenPresented) {
            DragIndicatorSheet(label: ".hidden — grabber should be gone") {
                isHiddenPresented = false
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.hidden)
        }
        .sheet(isPresented: $isAutomaticPresented) {
            DragIndicatorSheet(label: ".automatic — default behavior") {
                isAutomaticPresented = false
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.automatic)
        }
        .toolbar {
            PlaygroundSourceLink(file: "PresentationDragIndicatorPlayground.swift")
        }
    }
}

struct DragIndicatorSheet: View {
    let label: String
    let dismiss: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(label)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.top, 24)
            Text("Compare the top edge of this sheet to the others.")
                .font(.footnote)
                .foregroundStyle(.secondary)
            Button("Tap to dismiss") {
                dismiss()
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
