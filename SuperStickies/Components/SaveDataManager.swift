//
//  SaveDataManager.swift
//  SuperStickies
//
//  Created by SunnyFlops on 31/05/2025.
//

import Foundation
import SwiftUI

struct StickyNote {
    var id: UUID
    var note: NSAttributedString
    var colour: Color
    var screenPos: String
}

func saveData(id: UUID, note: String, colour: Color) {
    let fileManager = FileManager.default
    
    let dd = URL.documentsDirectory
    let saveDataLocation = dd.appendingPathComponent("SuperStickies", isDirectory: true)
    
    try? fileManager.createDirectory(at: saveDataLocation, withIntermediateDirectories: false)
    
    let fileURL = saveDataLocation.appendingPathComponent("\(id).rtf")

    try? Data(note.utf8).write(to: fileURL)
}

func loadData() {
    let fileManager = FileManager.default
    
    let dd = URL.documentsDirectory
    let saveDataLocation = dd.appendingPathComponent("SuperStickies", isDirectory: true)
    
    let items = try! fileManager.contentsOfDirectory(at: saveDataLocation, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
    
    for file in items {
        
    }
}
