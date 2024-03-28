//
//  Title.swift
//  Word Spell
//
//  Created by Brendan Kenney on 1/11/24.
//

import SwiftUI

struct Title: View {
    var body: some View {
        ZStack{
            Color.cyan
            Text("Word Spell")
                .font(.custom("AmericanTypewriter", size: 60))
            
        }
        .frame(height: 100)
    }
}

#Preview {
    Title()
}
