//
//  ContentView.swift
//  SuperStickies
//
//  Created by SunnyFlops on 27/05/2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store = StickyNoteStore.shared
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Sticky Notes").font(.title)
            List {
                ForEach(store.notes) { note in
                    Button(action: { openWindow(value: note.id) }) {
                        HStack {
                            Circle()
                                .fill(Color.fromStickyName(note.colourName))
                                .frame(width: 16, height: 16)
                            Text(NSAttributedString.fromRTF(note.rtfData).string.prefix(30) + "...")
                                .lineLimit(1)
                            Spacer()
                            Text(note.dateCreated, style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .contextMenu {
                        Button("Delete") { store.delete(note: note) }
                    }
                }
            }
            .frame(minHeight: 200)
            Button("New Sticky Note") { openWindow(value: UUID()) }
                .padding()
        }
        .padding()
        .onAppear { store.loadNotes() }
    }
}

// Helper to get Color from your sticky colour name
extension Color {
    static func fromStickyName(_ name: String) -> Color {
        switch name {
        case "stickyBlack": return .stickyBlack
        case "stickyBlue": return .stickyBlue
        case "stickyGrey": return .stickyGrey
        case "stickyGreen": return .stickyGreen
        case "stickyOrange": return .stickyOrange
        case "stickyPink": return .stickyPink
        case "stickyPurple": return .stickyPurple
        case "stickyRed": return .stickyRed
        case "stickyYellow": return .stickyYellow
        default: return .stickyYellow
        }
    }
}

// Helper to get NSAttributedString from RTF
extension NSAttributedString {
    static func fromRTF(_ data: Data) -> NSAttributedString {
        (try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)) ?? NSAttributedString(string: "")
    }
}
