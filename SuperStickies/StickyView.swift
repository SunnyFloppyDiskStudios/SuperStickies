//  StickyView.swift
//  SuperStickies
//
//  Created by SunnyFlops on 27/05/2025.
//

import Foundation
import SwiftUI

struct StickyNote: Identifiable, Codable {
    let id: UUID
    var rtfData: Data
    var colourName: String
    var dateCreated: Date
}

struct StickyView: View {
    var id: UUID

    @State var noteColour: Color = .stickyYellow
    @Environment(\.openWindow) var openWindow
    @State var pinned: Bool = false
    @State private var attributedNote = NSAttributedString(string: "")
    @State private var window: NSWindow? = nil
    @State private var showColours: Bool = false
    @State private var isDeleted = false

    @ObservedObject var manager = WindowManager.shared
    @ObservedObject var store = StickyNoteStore.shared

    var body: some View {
        VStack {
            TextArea(attributedText: $attributedNote, noteColour: noteColour)
        }
        .padding()
        .onAppear {
            store.loadNotes()
            if let loaded = store.getNote(by: id) {
                noteColour = Color.fromStickyName(loaded.colourName)
                attributedNote = NSAttributedString.fromRTFD(loaded.rtfData)
            } else {
                let emptyData = NSAttributedString(string: "").rtfdData()
                let newNote = StickyNote(
                    id: id,
                    rtfData: emptyData,
                    colourName: noteColour.stickyName,
                    dateCreated: Date()
                )
                store.save(note: newNote)
            }
        }
        .onDisappear {
            if !isDeleted { saveNote() }
        }
        .onChange(of: noteColour) {
            saveNote()
            window?.backgroundColor = NSColor(noteColour)
        }
        .onChange(of: attributedNote) { _ in
            saveNote()
        }
        .onWindow { _ in
            window?.backgroundColor = NSColor(noteColour)
        }
        .toolbar {
            Button {
                if !manager.openWindowIDs.contains("content") {
                    openWindow(id: "content")
                } else {
                    focusAllWindows(withTitle: "content")
                }
            } label: {
                Image(systemName: "line.3.horizontal")
                    .foregroundStyle(.black)
            }
            Button {
                openWindow(value: UUID())
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(.black)
            }
            Spacer()
            Button {
                pinned.toggle()
                window?.level = pinned ? .floating : .normal
            } label: {
                Image(systemName: pinned ? "pin.fill" : "pin")
                    .foregroundStyle(.black)
            }
            Button {
                showColours.toggle()
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.black)
            }
            .popover(isPresented: $showColours) {
                let colorOptions: [(name: String, color: Color)] = [
                    ("stickyBlack", .stickyBlack),
                    ("stickyGrey", .stickyGrey),
                    ("stickyBlue", .stickyBlue),
                    ("stickyGreen", .stickyGreen),
                    ("stickyOrange", .stickyOrange),
                    ("stickyPink", .stickyPink),
                    ("stickyPurple", .stickyPurple),
                    ("stickyRed", .stickyRed),
                    ("stickyYellow", .stickyYellow)
                ]
                HStack {
                    ForEach(colorOptions, id: \.name) { option in
                        Button {
                            noteColour = option.color
                        } label: {
                            Circle()
                                .fill(option.color)
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Circle()
                                        .stroke(noteColour == option.color ? Color.black : Color.clear, lineWidth: 3)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            Button {
                if let existing = store.getNote(by: id) {
                    store.delete(note: existing)
                }
                isDeleted = true
                window?.close()
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.black)
            }
        }
        .onWindow { win in
            self.window = win
        }
    }

    func saveNote() {
        let plainText = attributedNote.string.trimmingCharacters(in: .whitespacesAndNewlines)
        if plainText.isEmpty {
            if let existing = store.getNote(by: id) {
                store.delete(note: existing)
            }
            return
        }
        let rtfd = attributedNote.rtfdData()
        let note = StickyNote(
            id: id,
            rtfData: rtfd,
            colourName: noteColour.stickyName,
            dateCreated: Date()
        )
        store.save(note: note)
    }
}

