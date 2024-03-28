//
//  PokemonView.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/15/24.
//

import SwiftUI

struct PokemonView: View {
    @EnvironmentObject var manager : PokedexManager
    let pokemon : Pokemon
    var body: some View {
        VStack{
            PokemonImageView(image: pokemon.idFormattedToString(), hasID: true, types: pokemon.types)
                .frame(height: 400)
                .overlay(alignment: .topLeading){
                    CaptureButton(pokemon: manager.getPokemonFromID(id: pokemon.id))
                        .frame(width: 50, height: 30)
                        .offset(x: 15, y: 15)
                }
            HStack{
                VStack{
                    HeightAndWeight(height: pokemon.height, weight: pokemon.weight)
//                        .frame(width: 200)
                    TypesAndWeaknesses(title: "Types", types: pokemon.types)
                    TypesAndWeaknesses(title: "Weaknesses", types: pokemon.weaknesses)
                }
                .frame(width: 185)
                VStack{
                    Spacer()
                    Text("Previous Evolution(s)")
                    if(pokemon.prev_evolution.isEmpty){
                        Text("NA")
                    }else{
                        EvolutionView(pokemon: pokemon, preEvo: true)
                            .frame(width: 150, height: 125)
                    }
                    Spacer()
                    Text("Next Evolution(s)")
                    if(pokemon.next_evolution.isEmpty){
                        Text("NA")
                    }else{
                        EvolutionView(pokemon: pokemon, preEvo: false)
                            .frame(height: 125)
                    }
                    Spacer()
                }
                .fontWeight(.bold)
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    PokemonView(pokemon: Pokemon.mainDefault)
        .environmentObject(PokedexManager())
}
