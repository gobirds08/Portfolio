//
//  PokemonImageView.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/15/24.
//

import SwiftUI

struct PokemonImageView: View {
    let image : String
    let hasID : Bool
    let types : [PokemonType]
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            RoundedRectangle(cornerRadius: 25.0)
                .foregroundStyle(LinearGradient(types: types))
                .overlay{
                    Image(image)
                        .resizable()
                        .padding()
                        .aspectRatio(contentMode: .fit)
                }
            if(hasID){
                Text(image)
                    .font(.largeTitle)
                    .offset(x: -20, y: -8)
            }
        }
    }
}

extension LinearGradient{
    init(types: [PokemonType]){
        var colors : [Color] = []
        for type in types {
            colors.append(Color(pokemonType: type))
        }
        self = LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

#Preview {
    PokemonImageView(image: "001", hasID: true, types: [PokemonType.dragon, PokemonType.grass])
}
