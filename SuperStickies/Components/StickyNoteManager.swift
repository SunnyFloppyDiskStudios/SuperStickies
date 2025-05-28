//
//  StickyNoteManager.swift
//  SuperStickies
//
//  Created by SunnyFlops on 29/05/2025.
//

import Foundation
import SwiftUI

class StickyNoteManager: ObservableObject {
    @Published var notes: [UUID: StickyNoteModel] = [:]

    func note(for id: UUID?) -> StickyNoteModel {
        let key = id ?? UUID()
        if let existing = notes[key] {
            return existing
        } else {
            let new = StickyNoteModel(id: key)
            notes[key] = new
            return new
        }
    }
}
