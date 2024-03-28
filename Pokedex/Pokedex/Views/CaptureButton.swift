//
//  CaptureButton.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/19/24.
//

import SwiftUI

struct CaptureButton: View {
    @EnvironmentObject var manager : PokedexManager
    var pokemon : Pokemon
    var body: some View {
        let index = manager.getIndexFromPokemon(new: pokemon)
        Button{
            manager.pokemon[index].toggleCaptured()
        }label:{
            Capsule()
                .overlay{
                    Image(systemName: pokemon.captured ? "lock.fill" : "lock.open.fill")
                        .foregroundStyle(Color("AccentColor"))
                }
        }
    }
}

#Preview {
    CaptureButton(pokemon: Pokemon.mainDefault)
        .environmentObject(PokedexManager())
}
