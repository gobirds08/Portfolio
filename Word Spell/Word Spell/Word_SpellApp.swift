//
//  Word_SpellApp.swift
//  Word Spell
//
//  Created by Brendan Kenney on 1/11/24.
//

import SwiftUI

@main
struct Word_SpellApp: App {
    @StateObject var gameManager : GameManager = GameManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameManager)
        }
    }
}
