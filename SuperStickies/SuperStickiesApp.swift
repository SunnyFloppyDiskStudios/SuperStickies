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
        WindowGroup {
            StickyView()
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                .containerBackground(.stickyYellow, for: .window)
        }
        .defaultSize(width: 100, height: 100)
        .windowStyle(.hiddenTitleBar)
    }
}
