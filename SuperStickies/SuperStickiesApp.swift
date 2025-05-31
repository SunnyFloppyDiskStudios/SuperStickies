//
//  SuperStickiesApp.swift
//  SuperStickies
//
//  Created by SunnyFlops on 27/05/2025.
//

import SwiftUI

@main
struct SuperStickiesApp: App {
    var body: some Scene {
        WindowGroup("Sticky", for: UUID.self) { $id in
            if let id = id {
                StickyView(id: id)
                    .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
            } else {
                StickyView(id: UUID())
                    .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
            }
        }
        .defaultSize(width: 320, height: 320)
        .windowStyle(.hiddenTitleBar)
        .handlesExternalEvents(matching: ["sticky"])
    }
}
