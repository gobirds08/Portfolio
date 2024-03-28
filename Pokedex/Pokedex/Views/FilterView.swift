//
//  FilterView.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/19/24.
//

import SwiftUI

struct FilterView: View {
    @EnvironmentObject var manager : PokedexManager
    var body: some View {
        Menu{
            Button{
                manager.setListNoFilter()
            }label:{
                Text("Remove Filter")
            }
            ForEach(PokemonType.allCases){ type in
                Button{
                    manager.changeList(type: type)
                }label:{
                    Text(type.rawValue)
                }
            }
        }label:{
            Capsule()
                .overlay{
                    Text("Filter")
                        .foregroundStyle(Color("TextColor"))
                }
        }
    }
}

#Preview {
    FilterView()
        .environmentObject(PokedexManager())
}
