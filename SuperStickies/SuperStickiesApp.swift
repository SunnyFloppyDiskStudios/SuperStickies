//
//  SuperStickiesApp.swift
//  SuperStickies
//
//  Created by SunnyFlops on 27/05/2025.
//

import SwiftUI

@main
struct SuperStickiesApp: App {
    @StateObject private var manager = StickyNoteManager()

    var body: some Scene {
        WindowGroup("Sticky", for: UUID.self) { $id in
            if let id = id {
                StickyViewLoader(id: id, manager: manager)
            } else {
                let newId = UUID()
                StickyViewLoader(id: newId, manager: manager)
            }
        }
        .defaultSize(width: 320, height: 320)
        .windowStyle(.hiddenTitleBar)
        .handlesExternalEvents(matching: ["sticky"])
    }
}
