//
//  PreferencesView.swift
//  Word Spell
//
//  Created by Brendan Kenney on 1/27/24.
//

import SwiftUI

struct PreferencesView: View {
    @Binding var preferences : Preferences
    var body: some View {
        Form {
            Section(header: Text("Language Settings")){
                Picker("Language:", selection: $preferences.language){
                    ForEach(Language.allCases){
                        Text($0.rawValue)
                            .tag($0)
                    }
                }
            }
            .pickerStyle(.segmented)
            Section(header: Text("Number of Letters")){
                Picker("Problem Size:", selection: $preferences.numLetter){
                    ForEach(ProblemSize.allCases){
                        Text($0.rawValue)
                            .tag($0)
                    }
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

#Preview {
    PreferencesView(preferences: .constant(Preferences.mainDefault))
}
