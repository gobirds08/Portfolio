//
//  RowView.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/16/24.
//

import SwiftUI

struct RowView: View {
    let pokemon : Pokemon
    var body: some View {
        HStack{
            VStack(spacing: 10){
                Text(pokemon.idFormattedToString())
                Image(systemName: pokemon.captured ? "lock.fill" : "lock.open.fill")
            }
            .frame(width: 40)
            Text(pokemon.name)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.system(size: 20))
                .frame(width: 150)
            Spacer()
            PokemonImageView(image: pokemon.idFormattedToString(), hasID: false, types: pokemon.types)
                .frame(width: 100, height: 100)
            Spacer()
        }
    }
}

#Preview {
    RowView(pokemon: Pokemon.mainDefault)
}
