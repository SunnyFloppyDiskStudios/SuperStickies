//
//  ContentView.swift
//  SuperStickies
//
//  Created by SunnyFlops on 27/05/2025.
//

import SwiftUI

struct StickyView: View {
    @ObservedObject var model: StickyNoteModel
        
    @Environment(\.openWindow) var openWindow
    
    @State private var fileName: String = ""
    
    @State private var window: NSWindow? = nil
    
    @State private var showColours: Bool = false

    var body: some View {
        VStack {
            TextArea(text: $model.note, noteColour: model.noteColour)
        }
        .padding()
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

            Button {
                // pin
                model.pinned.toggle()
                window?.level = model.pinned ? .floating : .normal
            } label: {
                Image(systemName: model.pinned ? "pin.fill" : "pin")
                    .foregroundStyle(.black)
            }

            Spacer()

            Button {
                showColours.toggle()
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.black)
            }
            .popover(isPresented: $showColours) {
                HStack {
                    Button {
                        model.noteColour = .stickyBlack
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyBlack)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        model.noteColour = .stickyGrey
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyGrey)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        model.noteColour = .stickyBlue
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyBlue)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        model.noteColour = .stickyGreen
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyGreen)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        model.noteColour = .stickyOrange
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyOrange)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        model.noteColour = .stickyPink
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyPink)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        model.noteColour = .stickyPurple
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyPurple)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        model.noteColour = .stickyRed
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyRed)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        model.noteColour = .stickyYellow
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyYellow)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }

            Button {
                // save (as rtf)
            } label: {
                Image(systemName: "internaldrive.fill")
                    .foregroundStyle(.black)
            }
        }
        .onWindow { win in
            self.window = win
        }
    }
}
