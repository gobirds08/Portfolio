//
//  EvolutionView.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/19/24.
//

import SwiftUI

struct EvolutionView: View {
    @EnvironmentObject var manager : PokedexManager
    let pokemon : Pokemon
    let preEvo : Bool
    var body: some View {
        ScrollView(.horizontal){
            HStack(spacing: 10){
                ForEach(preEvo ? pokemon.prev_evolution : pokemon.next_evolution, id: \.self){ i in
                    let new = manager.getPokemonFromID(id: i)
                    NavigationLink{
                        PokemonView(pokemon: manager.getPokemonFromID(id: i))
                    }label:{
                        CardView(pokemon: new)
                            .frame(width: 125)
                    }
                }
            }
        }
    }
}

#Preview {
    EvolutionView(pokemon: Pokemon.mainDefault, preEvo: false)
        .environmentObject(PokedexManager())
}
