//
//  ContentView.swift
//  SuperStickies
//
//  Created by SunnyFlops on 27/05/2025.
//

import SwiftUI

struct StickyView: View {
    @State private var fileName: String = ""
    @State private var pinned: Bool = false
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .foregroundStyle(.black)
        }
        .padding()
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(.black)
            }
            
            Button {
                pinned = !pinned
            } label: {
                Image(systemName: pinned ? "pin.fill" : "pin")
                    .foregroundStyle(.black)
            }
            
            Spacer()
            
            TextField(
                fileName,
                text: $fileName
            )
            .foregroundStyle(.black)
            .textFieldStyle(.roundedBorder)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(.black)
            }
            
            Button {
                
            } label: {
                Image(systemName: "internaldrive.fill")
                    .foregroundStyle(.black)
            }
        }
    }
}
