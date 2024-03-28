//
//  Score.swift
//  Word Spell
//
//  Created by Brendan Kenney on 1/11/24.
//

import SwiftUI

struct Score: View {
    @EnvironmentObject var gameManager : GameManager
    let score: Int
    var body: some View {
        Text("\(score)")
            .font(.custom("Huge", size: 100))
            .frame(height: 100)
    }
        
}

#Preview {
    Score(score: 0)
        .environmentObject(GameManager())
}
