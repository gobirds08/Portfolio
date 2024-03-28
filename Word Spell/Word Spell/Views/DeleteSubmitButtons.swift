//
//  DeleteSubmitButtons.swift
//  Word Spell
//
//  Created by Brendan Kenney on 1/11/24.
//

import SwiftUI

struct DeleteSubmitButtons: View {
    @EnvironmentObject var gameManager : GameManager
    var body: some View {
        HStack{
            Button(action: {gameManager.delete()}){
                Image(systemName: "delete.left")
                    .foregroundStyle(.red)
            }
            .disabled(gameManager.wordFormingEmpty)
            Spacer()
            Button(action: {gameManager.submit()}){
                Image(systemName: "arrow.up")
            }
            .disabled(!gameManager.isValid)
            .tint(gameManager.isValid ? .green : .blue)
            
        }
        .padding()
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .foregroundStyle(.black)
        .font(.system(size: 25))
        
    }
}

#Preview {
    DeleteSubmitButtons()
        .environmentObject(GameManager())
}
