//
//  TypesAndWeaknesses.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/16/24.
//

import SwiftUI

struct TypesAndWeaknesses: View {
    let title : String
    let types : [PokemonType]
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .font(.headline)
                Spacer()
            }
            ScrollView(.horizontal){
                HStack(){
                    ForEach(types){ type in
                        Text(type.rawValue)
                            .padding(10)
                            .background(Color(pokemonType: type))
                            .cornerRadius(25)
                            .font(.headline)
                    }
                }
            }
        }
        .padding()
    }
}

extension Color{
    init(type: PokemonType){
        switch type.rawValue{
        case "Bug":
            self = .purple
        case "Dragon":
            self = .teal
        case "Electric":
            self = .yellow
        case "Fighting":
            self = .red
        case "Fire":
            self = .orange
        case "Flying":
            self = .pink
        case "Ghost":
            self = .cyan
        case "Grass":
            self = .green
        case "Ground":
            self = .brown
        case "Ice":
            self = .mint
        case "Normal":
            self = .indigo
        case "Poison":
            self = Color(red: 144/255, green: 238/255, blue: 144/255)
        case "Psychic":
            self = Color(red: 210/255, green: 180/255, blue: 140/255)
        case "Rock":
            self = .gray
        case "Water":
            self = .blue
        default:
            self = .white
        }
    }
}

#Preview {
    TypesAndWeaknesses(title: "Types", types: [PokemonType.dragon, PokemonType.fire])
}
