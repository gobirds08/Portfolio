//
//  ContentView.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/14/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager : PokedexManager
    var body: some View {
        NavigationStack{
            List{
                ForEach(manager.pokemonList){ pokemon in
                    NavigationLink{
                        PokemonView(pokemon: pokemon)
                    }label:{
                        RowView(pokemon: pokemon)
                    }
                }
            }
            .foregroundStyle(Color("TextColor"))
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PokedexManager())
}
