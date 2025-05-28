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
    
    @State private var fileName: String = ""
    @State var pinned: Bool = false
    
    @State private var note: String = ""
    
    @State private var window: NSWindow? = nil
    
    @State private var showColours: Bool = false

    var body: some View {
        VStack {
            TextArea(text: $note)
            
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
                pinned.toggle()
                window?.level = pinned ? .floating : .normal
            } label: {
                Image(systemName: pinned ? "pin.fill" : "pin")
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
                        noteColour = .stickyBlack
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyBlack)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        noteColour = .stickyGrey
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyGrey)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        noteColour = .stickyBlue
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyBlue)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        noteColour = .stickyGreen
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyGreen)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        noteColour = .stickyOrange
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyOrange)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        noteColour = .stickyPink
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyPink)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        noteColour = .stickyPurple
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyPurple)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        noteColour = .stickyRed
                    } label: {
                        Circle()
                            .foregroundStyle(.stickyRed)
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        noteColour = .stickyYellow
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
