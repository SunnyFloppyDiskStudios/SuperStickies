//
//  SaveDataManager.swift
//  SuperStickies
//
//  Created by SunnyFlops on 31/05/2025.
//

import Foundation
import SwiftUI
import Combine
import AppKit

class StickyNoteStore: ObservableObject {
    static let shared = StickyNoteStore()
    @Published var notes: [StickyNote] = []

    private let notesDirectory: URL = {
        let dir = URL.documentsDirectory
        let notesDir = dir.appendingPathComponent("SuperStickies", isDirectory: true)
        try? FileManager.default.createDirectory(at: notesDir, withIntermediateDirectories: true)
        return notesDir
    }()

    func save(note: StickyNote) {
        let url = notesDirectory.appendingPathComponent("\(note.id.uuidString).json")
        if let data = try? JSONEncoder().encode(note) {
            try? data.write(to: url)
            loadNotes()
        }
    }

    func delete(note: StickyNote) {
        let url = notesDirectory.appendingPathComponent("\(note.id.uuidString).json")
        try? FileManager.default.removeItem(at: url)
        loadNotes()
    }

    func loadNotes() {
        let files = (try? FileManager.default.contentsOfDirectory(at: notesDirectory, includingPropertiesForKeys: nil)) ?? []
        let loaded = files.compactMap { url -> StickyNote? in
            guard let data = try? Data(contentsOf: url) else { return nil }
            return try? JSONDecoder().decode(StickyNote.self, from: data)
        }
        DispatchQueue.main.async {
            self.notes = loaded.sorted { $0.dateCreated > $1.dateCreated }
        }
    }

    func getNote(by id: UUID) -> StickyNote? {
        notes.first { $0.id == id }
    }
}

extension NSAttributedString {
    func rtfdData() -> Data {
        guard let wrapper = try? self.fileWrapper(
            from: NSRange(location: 0, length: length),
            documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd]
        ) else {
            return Data()
        }
        return wrapper.serializedRepresentation!
    }
}

extension Color {
    var stickyName: String {
        if self == .stickyBlack { return "stickyBlack" }
        if self == .stickyBlue { return "stickyBlue" }
        if self == .stickyGrey { return "stickyGrey" }
        if self == .stickyGreen { return "stickyGreen" }
        if self == .stickyOrange { return "stickyOrange" }
        if self == .stickyPink { return "stickyPink" }
        if self == .stickyPurple { return "stickyPurple" }
        if self == .stickyRed { return "stickyRed" }
        if self == .stickyYellow { return "stickyYellow" }
        return "stickyYellow"
    }
}

extension NSAttributedString {
    static func fromRTFD(_ data: Data) -> NSAttributedString {
        guard let wrapper = try? FileWrapper(serializedRepresentation: data) else {
            return NSAttributedString(string: "")
        }
        return (try? NSAttributedString(
            rtfdFileWrapper: wrapper,
            documentAttributes: nil
        )) ?? NSAttributedString(string: "")
    }
}
