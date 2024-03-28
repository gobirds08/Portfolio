//
//  WordForming.swift
//  Word Spell
//
//  Created by Brendan Kenney on 1/11/24.
//

import SwiftUI

struct WordForming: View {
    @EnvironmentObject var gameManager : GameManager
    let lettersFormed: [String]
    var body: some View {
        ZStack{
            Color.blue
            HStack{
                ForEach(lettersFormed, id:\.self){ letter in
                    Text("\(letter)")
                }
        
            }
            .font(.title)
        }
        .frame(height: 60)
    }
}

#Preview {
    WordForming(lettersFormed: ["h"])
        .environmentObject(GameManager())
}
