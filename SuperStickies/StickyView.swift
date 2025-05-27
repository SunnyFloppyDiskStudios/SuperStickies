//
//  ContentView.swift
//  SuperStickies
//
//  Created by SunnyFlops on 27/05/2025.
//

import SwiftUI

struct StickyView: View {
    @State private var fileName: String = ""
    @State var pinned: Bool = false
    @State private var note: String = ""
    @State private var window: NSWindow? = nil

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
                // new
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(.black)
            }

            Button {
                pinned.toggle()
                window?.level = pinned ? .floating : .normal
            } label: {
                Image(systemName: pinned ? "pin.fill" : "pin")
                    .foregroundStyle(.black)
            }

            Spacer()

            Button {
                // colours and formatting
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.black)
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
