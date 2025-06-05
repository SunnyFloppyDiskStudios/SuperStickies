//
//  WindowManager.swift
//  SuperStickies
//
//  Created by SunnyFlops on 06/06/2025.
//

import Foundation
import AppKit

class WindowManager: ObservableObject {
    static let shared = WindowManager()
    @Published var openWindowIDs: Set<String> = []
}

func focusAllWindows(withTitle title: String) {
    for window in NSApp.windows {
        if window.title == title {
            window.makeKeyAndOrderFront(nil)
        }
    }
}
