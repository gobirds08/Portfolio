//
//  RowsOfCardsView.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/19/24.
//

import SwiftUI

struct RowsOfCardsView: View {
    @EnvironmentObject var manager : PokedexManager
    let pokemons : [Pokemon]
    let typeName : String
    let color : Color
//    let type : PokemonType
    var body: some View {
        VStack(spacing: 10){
            Capsule()
                .foregroundStyle(color)
                .overlay{
                    HStack{
                        Text(typeName)
                            .offset(x: 30)
                            .fontWeight(.bold)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }
                }
                .frame(height: 50)
            
                ScrollView(.horizontal){
                    HStack(spacing: 10){
                        ForEach(pokemons){ pokemon in
                            let id = pokemon.id
                            NavigationLink{
                                PokemonView(pokemon: manager.getPokemonFromID(id: id))
                            }label:{
                                CardView(pokemon: manager.getPokemonFromID(id: id))
                                    .frame(width: 170, height: 200)
                            }
                        }
                    }
                }
            
        }
        .frame(height: 300)
    }
}

#Preview {
    RowsOfCardsView(pokemons: [Pokemon.mainDefault, Pokemon.mainDefaultTwo], typeName: "Dragon", color: Color(pokemonType: PokemonType.dragon))
        .environmentObject(PokedexManager())
}
