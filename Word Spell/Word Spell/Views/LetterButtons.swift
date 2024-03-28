//
//  LetterButtons.swift
//  Word Spell
//
//  Created by Brendan Kenney on 1/11/24.
//

import SwiftUI

struct LetterButtons: View {
    @EnvironmentObject var gameManager : GameManager
    let word: [String]
    var body: some View {
        GeometryReader { geometry in
//            HStack{
                
                ForEach(word, id:\.self){ letter in
                    
                        Button(){
                            gameManager.letterPressed(letter: letter)
                        }label:{
                            ZStack {
                                LetterShapes(sides: gameManager.game.letterCount)
                                    .foregroundStyle(gameManager.game.yellowLetter != letter ? .gray : .yellow)
                                    .rotationEffect(gameManager.isSquare() ? .degrees(45) : !gameManager.isPentagon() ? .degrees(0) : gameManager.game.yellowLetter != letter ? .degrees(18) : .degrees(54))
                                Text("\(letter)")
                                    .foregroundStyle(.black)
                            }

                            
                        }
                        .font(.title)
                        .position(gameManager.getOffset(sides: gameManager.game.letterCount, letter: letter, size: geometry.size))
                        .frame(width: 50, height: 50)
                    
                    
                }
//            }
//            .padding()
//            .font(.system(size: 25))
        }
    }
}


#Preview {
    LetterButtons(word: ["l", "o", "h", "m", "p"])
        .environmentObject(GameManager())
}
