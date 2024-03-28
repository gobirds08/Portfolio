//
//  WordsList.swift
//  Word Spell
//
//  Created by Brendan Kenney on 1/11/24.
//

import SwiftUI

struct WordsList: View {
    @EnvironmentObject var gameManager : GameManager
    let wordsCreated: [String]
    var body: some View {
        ZStack{
            Color.cyan
            ScrollView(.horizontal, showsIndicators: true){
                    HStack{
                        ForEach(wordsCreated, id: \.self) { word in
                            Text("\(word)")
                            Spacer()
                        }
                        
                    }
                    .padding()
                    .bold()
                    .font(.title2)
                    .textCase(.lowercase)
                }
            }
        .frame(height: 60)
    }
}

#Preview {
    WordsList(wordsCreated: ["hello", "where", "north", "help", "over", "near", "there"])
        .environmentObject(GameManager())
}
