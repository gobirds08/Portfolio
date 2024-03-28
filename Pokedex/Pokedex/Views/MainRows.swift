//
//  MainRows.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/19/24.
//

import SwiftUI

struct MainRows: View {
    @EnvironmentObject var manager : PokedexManager
    var body: some View {
        NavigationStack{
            ScrollView(.vertical){
                VStack{
                    HStack{
                        Spacer()
                        NavigationLink{
                            PokemonList()
                        }label:{
                            Capsule()
                                .overlay{
                                    Text("View Full List")
                                        .foregroundStyle(Color("TextColor"))
                                }
                                .foregroundColor(Color("AccentColor"))
                                .frame(width: 150, height: 30)
                        }
                    }
                    if(!manager.capturedPokemon.isEmpty){
                        RowsOfCardsView(pokemons: manager.capturedPokemon, typeName: "Captured", color: Color.clear)
                            .padding()
                    }
                    ForEach(PokemonType.allCases){ type in
                        let pokemon = manager.getPokemonFromType(type: type)
                        RowsOfCardsView(pokemons: pokemon, typeName: type.rawValue, color: Color(pokemonType: type))
                            .padding()
                    }
                }
            }
        }
        .foregroundStyle(Color("TextColor"))
    }
}

#Preview {
    MainRows()
        .environmentObject(PokedexManager())
}
