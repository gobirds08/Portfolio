//
//  HeightView.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/15/24.
//

import SwiftUI

struct HeightView: View {
    let height : Double
    var body: some View {
        VStack{
            Text("Height")
                .font(.system(size: 17))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            HStack(spacing: 1){
                Text(String(height))
                    .fontWeight(.bold)
                    .font(.system(size: 22.0))
                Text("m")
            }
        }
    }
}

#Preview {
    HeightView(height: 0.30)
}
