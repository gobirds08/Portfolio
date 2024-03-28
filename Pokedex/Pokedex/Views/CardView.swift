//
//  CardView.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/19/24.
//

import SwiftUI

struct CardView: View {
    let pokemon : Pokemon
    var body: some View {
        VStack{
            PokemonImageView(image: pokemon.idFormattedToString(), hasID: false, types: pokemon.types)
            HStack{
                Spacer()
                Text(pokemon.name)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Spacer()
                Image(systemName: pokemon.captured ? "lock.fill" : "lock.open.fill")
                Spacer()
            }
            .font(.system(size: 20))
        }
    }
}

#Preview {
    CardView(pokemon: Pokemon.mainDefault)
}
