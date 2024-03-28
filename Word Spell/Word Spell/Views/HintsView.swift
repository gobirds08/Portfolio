//
//  HintsView.swift
//  Word Spell
//
//  Created by Brendan Kenney on 1/27/24.
//

import SwiftUI

struct HintsView: View {
    @EnvironmentObject var gameManager : GameManager
    var body: some View {

            VStack(spacing: 0){
                Form {
                    Section(header: Text("Possibles")){
                        HStack{
                            Text("Possible Words: ")
                            Spacer()
                            Text("\(gameManager.hints.totalWords)")
                        }
                        HStack{
                            Text("Possible Points: ")
                            Spacer()
                            Text("\(gameManager.hints.totalPoints)")
                        }
                        HStack{
                            Text("Possible Pangrams: ")
                            Spacer()
                            Text("\(gameManager.hints.pangrams)")
                        }
                    }
                    
                        let wordDictionary = gameManager.hints.wordLengths
                        let keys : [Int] = Array(wordDictionary.keys)
                        //iterates over lengths
                        ForEach(keys, id: \.self){ key in

                            Section(header: Text("Length \(key)")){
                            if let firstLetterDictionary = wordDictionary[key]{
                                ForEach(Array(firstLetterDictionary.keys), id: \.self){ lKey in
                                    HStack{
                                        Text("\(lKey)")
                                        Spacer()
                                        Text("\(firstLetterDictionary[lKey]!)")
                                    }
                                }
                            }
                          
                            }
                        }

                    
                }
            }//end of VStack
    }
}

#Preview {
    HintsView()
        .environmentObject(GameManager())
}
