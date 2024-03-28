//
//  ContentView.swift
//  Word Spell
//
//  Created by Brendan Kenney on 1/11/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameManager : GameManager
    @State private var showPreferences = false
    @State private var showHints = false
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            VStack {
                Title()
                Score(score: gameManager.score)
                VStack(spacing: 0){
                    WordsList(wordsCreated: gameManager.wordsFormed)
                    WordForming(lettersFormed: gameManager.wordForming)
                }
                LetterButtons(word: gameManager.game.letters)
                DeleteSubmitButtons()
                BottomButtons(showPreferences: $showPreferences, showHints: $showHints)
            }
        }
        .sheet(isPresented: $showPreferences, content: {
            PreferencesView(preferences: $gameManager.preferences)
        })
        .sheet(isPresented: $showHints, content: {
            HintsView()
        })
        
    }
}

#Preview {
    ContentView()
        .environmentObject(GameManager())
}
