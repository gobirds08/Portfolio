//
//  WeightView.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/15/24.
//

import SwiftUI

struct WeightView: View {
    let weight: Double
    var body: some View {
        VStack{
            Text("Weight")
                .font(.system(size: 17))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            HStack(spacing: 1){
                Text(String(weight))
                    .fontWeight(.bold)
                    .font(.system(size: 22.0))
                Text("kg")
            }
        }
    }
}

#Preview {
    WeightView(weight: 20.25)
}
