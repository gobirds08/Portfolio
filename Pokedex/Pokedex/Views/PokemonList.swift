//
//  PokemonList.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/19/24.
//

import SwiftUI

struct PokemonList: View {
    @EnvironmentObject var manager : PokedexManager
    var body: some View {
        VStack{
            NavigationStack{
                HStack{
                    Spacer()
                    FilterView()
                        .frame(width: 150, height: 30)
                        .foregroundStyle(Color("AccentColor"))
                }
                List{
                    ForEach(manager.pokemonList){ pokemon in
                        NavigationLink{
                            let id = pokemon.id
                            PokemonView(pokemon: manager.getPokemonFromID(id: id))
                        }label:{
                            RowView(pokemon: pokemon)
                        }
                    }
                }
                .foregroundStyle(Color("TextColor"))
            }
        }
    }
}

#Preview {
    PokemonList()
        .environmentObject(PokedexManager())
}
