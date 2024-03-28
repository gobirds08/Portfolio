//
//  BottomButtons.swift
//  Word Spell
//
//  Created by Brendan Kenney on 1/11/24.
//

import SwiftUI

struct BottomButtons: View {
    @EnvironmentObject var gameManager : GameManager
    @Binding var showPreferences : Bool
    @Binding var showHints : Bool
    var body: some View {
        HStack{
            Button(action: {gameManager.shuffle()}){
                Image(systemName: "shuffle")
            }
            Spacer()
            Button(action: {showHints.toggle()
                                if(gameManager.isFirstRound()){
                                    gameManager.calculateHints()
                                }
            }){
                Image(systemName: "questionmark.circle")
                    
            }
            Spacer()
            Button(action: {showPreferences.toggle()}){
                Image(systemName: "gearshape")
            }
            Spacer()
            Button(action: {gameManager.newGame()}){
                Image(systemName: "plus")
            }
        }
        .padding()
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .font(.system(size: 25))
        .foregroundStyle(.black)
        
        
    }
}
//#Preview {
//    BottomButtons(showPreferences: .constant(true), showHints: .constant(false))
//        .environmentObject(GameManager())
//}
