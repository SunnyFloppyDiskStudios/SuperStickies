//
//  StickyNoteModel.swift
//  SuperStickies
//
//  Created by SunnyFlops on 29/05/2025.
//

import Foundation
import SwiftUI

class StickyNoteModel: ObservableObject, Identifiable {
    let id: UUID
    @Published var note: String
    @Published var noteColour: Color
    @Published var pinned: Bool

    init(id: UUID = UUID(), note: String = "", noteColour: Color = .stickyYellow, pinned: Bool = false) {
        self.id = id
        self.note = note
        self.noteColour = noteColour
        self.pinned = pinned
    }
}

enum StickyColours: CaseIterable {
    case stickyBlack, stickyGrey, stickyBlue, stickyGreen, stickyOrange, stickyPink, stickyPurple, stickyRed, stickyYellow

    var colour: Color {
        switch self {
        case .stickyBlack: return .stickyBlack
        case .stickyGrey: return .stickyGrey
        case .stickyBlue: return .stickyBlue
        case .stickyGreen: return .stickyGreen
        case .stickyOrange: return .stickyOrange
        case .stickyPink: return .stickyPink
        case .stickyPurple: return .stickyPurple
        case .stickyRed: return .stickyRed
        case .stickyYellow: return .stickyYellow
        }
    }
}
