//
//  HeightAndWeight.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/15/24.
//

import SwiftUI

struct HeightAndWeight: View {
    let height: Double
    let weight: Double
    var body: some View {
        HStack(spacing: 10){
            Spacer()
            HeightView(height: height)
            WeightView(weight: weight)
            Spacer()
        }
    }
}

#Preview {
    HeightAndWeight(height: 20.3, weight: 30.45)
}
