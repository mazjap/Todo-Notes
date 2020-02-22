//
//  NotesController.swift
//  Todo
//
//  Created by Jordan Christensen on 2/10/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation

class NotesController {
    private var userDefaults = UserDefaults.standard
    private var notesKey = "userdefaults.text"
    private var fontKey = "userdefaults.font"
    
    func saveNotesToPersistantStore(_ text: String) {
        userDefaults.set(text, forKey: notesKey)
    }
    
    func loadNotesFromPersistantStore() -> String {
        if let text = userDefaults.string(forKey: notesKey) {
            return text
        }
        return ""
    }
    
    func saveFontToPersistantStore(_ text: String) {
        userDefaults.set(text, forKey: fontKey)
    }
    
    func loadFontFromPersistantStore() -> String? {
        if let text = userDefaults.string(forKey: fontKey) {
            return text
        }
        return "Write your notes here, they'll aways be saved"
    }
}
