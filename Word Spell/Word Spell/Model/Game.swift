//
//  Game.swift
//  Word Spell
//
//  Created by Brendan Kenney on 1/18/24.
//

import Foundation

struct ScrambleProblem{
    var letters : [String]
    var letterCount : Int
    var yellowLetter : String
    var wordsAllowed : [String]
    var preferences : Preferences
    
    init(letters: [String], letterCount: Int, preferences: Preferences, yellowLetter : String, wordsAllowed : [String]){
        self.letters = letters
        self.letterCount = letterCount
        self.preferences = preferences
        self.yellowLetter = yellowLetter
        self.wordsAllowed = wordsAllowed
    }
}



struct Preferences {
    var language : Language
    var numLetter : ProblemSize
    
    static let mainDefault = Preferences(language: Language.english, numLetter: ProblemSize.five)
}

enum Language : String, CaseIterable, Identifiable {
    var id: RawValue {rawValue}
    
    case english, french
}

enum ProblemSize : String, CaseIterable, Identifiable {
    var id: RawValue {rawValue}
    
    case five, six, seven
}

struct Hints {
    var totalWords : Int
    var totalPoints : Int
    var pangrams : Int
    var wordLengths : [Int : [String : Int]]
}

