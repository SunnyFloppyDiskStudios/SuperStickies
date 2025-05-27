//
//  WindowAccessor.swift
//  SuperStickies
//
//  Created by SunnyFlops on 27/05/2025.
//

import Foundation
import AppKit
import SwiftUI

extension View {
    func onWindow(_ perform: @escaping (NSWindow) -> Void) -> some View {
        self.background(WindowAccessor(callback: perform))
    }
}

private struct WindowAccessor: NSViewRepresentable {
    let callback: (NSWindow) -> Void
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                self.callback(window)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

