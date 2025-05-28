//
//  StickyViewLoader.swift
//  SuperStickies
//
//  Created by SunnyFlops on 29/05/2025.
//

import Foundation
import SwiftUI

struct StickyViewLoader: View {
    let id: UUID
    @ObservedObject var manager: StickyNoteManager
    @State private var model: StickyNoteModel?

    var body: some View {
        Group {
            if let model {
                StickyView(model: model)
                    .containerBackground(model.noteColour, for: .window)
                    .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
            } else {
                ProgressView()
            }
        }
        .task {
            if model == nil {
                model = manager.note(for: id)
            }
        }
    }
}
