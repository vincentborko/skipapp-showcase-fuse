// Copyright 2023–2025 Skip
import SwiftUI

/// Demonstrates `.presentationSizing(_:)`, which requests how wide a presented sheet should be.
///
/// On Android a presentation is always a Compose `ModalBottomSheet`, whose only sizing lever is
/// `sheetMaxWidth`. skip-ui maps the sizings as:
///   • `.page`           → fills the available width
///   • `.form` / `.fitted` → capped to a narrower, form-like width (360pt)
///   • `.automatic`      → the Material default (≈640pt)
///
/// Exactly like SwiftUI on a compact-width iPhone, the cap is only *visible* when the screen is wider
/// than the cap. So on a phone in **portrait** all the sheets look the same (full width); **rotate the
/// device to landscape** (or run on a tablet) to see `.form` become noticeably narrower than `.page`.
struct PresentationSizingPlayground: View {
    // internal (not private) so Skip can bridge the @State across to Compose.
    @State var isPagePresented = false
    @State var isFormPresented = false
    @State var isFittedPresented = false
    @State var isAutomaticPresented = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("presentationSizing requests how wide a presented sheet should be. On Android it maps to the bottom sheet's max width — only visible when the screen is wider than the cap. Rotate to landscape to compare .page (full width) vs .form (narrower).")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("Present sheet — .page (fills width)") {
                    isPagePresented = true
                }
                Button("Present sheet — .form (narrower)") {
                    isFormPresented = true
                }
                Button("Present sheet — .fitted (narrower)") {
                    isFittedPresented = true
                }
                Button("Present sheet — .automatic (default)") {
                    isAutomaticPresented = true
                }
            }
            .padding()
        }
        // `.presentationSizing` is iOS 18+ in Apple's SwiftUI (the iOS-native build path); SkipSwiftUI has
        // no version gate. Guard each call so the playground also compiles on iOS < 18.
        .sheet(isPresented: $isPagePresented) {
            if #available(iOS 18.0, *) {
                SizingSheet(label: ".page — should fill the available width") {
                    isPagePresented = false
                }
                .presentationDetents([.medium])
                .presentationSizing(.page)
            } else {
                SizingSheet(label: ".page (requires iOS 18+)") { isPagePresented = false }
                    .presentationDetents([.medium])
            }
        }
        .sheet(isPresented: $isFormPresented) {
            if #available(iOS 18.0, *) {
                SizingSheet(label: ".form — should be narrower (capped at 360pt)") {
                    isFormPresented = false
                }
                .presentationDetents([.medium])
                .presentationSizing(.form)
            } else {
                SizingSheet(label: ".form (requires iOS 18+)") { isFormPresented = false }
                    .presentationDetents([.medium])
            }
        }
        .sheet(isPresented: $isFittedPresented) {
            if #available(iOS 18.0, *) {
                SizingSheet(label: ".fitted — should be narrower (capped at 360pt)") {
                    isFittedPresented = false
                }
                .presentationDetents([.medium])
                .presentationSizing(.fitted)
            } else {
                SizingSheet(label: ".fitted (requires iOS 18+)") { isFittedPresented = false }
                    .presentationDetents([.medium])
            }
        }
        .sheet(isPresented: $isAutomaticPresented) {
            if #available(iOS 18.0, *) {
                SizingSheet(label: ".automatic — Material default width (≈640pt)") {
                    isAutomaticPresented = false
                }
                .presentationDetents([.medium])
                .presentationSizing(.automatic)
            } else {
                SizingSheet(label: ".automatic (requires iOS 18+)") { isAutomaticPresented = false }
                    .presentationDetents([.medium])
            }
        }
        .toolbar {
            PlaygroundSourceLink(file: "PresentationSizingPlayground.swift")
        }
    }
}

struct SizingSheet: View {
    let label: String
    let dismiss: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(label)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.top, 24)
            // A full-width colored band makes the sheet's actual width obvious against the dimmed backdrop.
            Rectangle()
                .fill(.blue.opacity(0.25))
                .frame(height: 60)
                .overlay(Text("← sheet width →").font(.caption))
            Text("Rotate to landscape and compare this sheet's width to the others.")
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
