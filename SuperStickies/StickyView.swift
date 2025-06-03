//
//  ContentView.swift
//  SuperStickies
//
//  Created by SunnyFlops on 27/05/2025.
//

import SwiftUI

struct StickyView: View {
    var id: UUID
    
    @State var noteColour: Color = .stickyYellow
    @Environment(\.openWindow) var openWindow
    @State var pinned: Bool = false
    @State private var attributedNote = NSAttributedString(string: "")
    @State private var window: NSWindow? = nil
    @State private var showColours: Bool = false

    var body: some View {
        VStack {
            TextArea(attributedText: $attributedNote, noteColour: noteColour)
        }
        .padding()
        .onChange(of: noteColour) { newColour in
            window?.backgroundColor = NSColor(newColour)
        }
        .onWindow {_ in
            window?.backgroundColor = NSColor(.stickyYellow)
        }
        .toolbar {
            Button {
                // menu
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
                HStack {
                    ForEach([
                        Color.stickyBlack, .stickyGrey, .stickyBlue,
                        .stickyGreen, .stickyOrange, .stickyPink,
                        .stickyPurple, .stickyRed, .stickyYellow
                    ], id: \.self) { colour in
                        Button {
                            noteColour = colour
                        } label: {
                            Circle().foregroundStyle(colour)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
        .onWindow { win in
            self.window = win
        }
    }
}
