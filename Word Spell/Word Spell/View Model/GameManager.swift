//
//  GameManager.swift
//  Word Spell
//
//  Created by Brendan Kenney on 1/18/24.
//

import Foundation

class GameManager : ObservableObject {
    
    //Model
    var game = ScrambleProblem(letters: ["t", "s", "a", "r", "p"], letterCount: 5, preferences: Preferences.mainDefault, yellowLetter: "t", wordsAllowed: Words.words)
    var hints : Hints = Hints(totalWords: 0, totalPoints: 0, pangrams: 0, wordLengths: [:])
    
    //Game Properties
    var score : Int = 0
    var wordsFormed : [String] = []
    var wordForming : [String] = []
    
    @Published var gameState = GameState.waiting
    @Published var preferences = Preferences.mainDefault
    @Published var firstRound = FirstGame.yes
    
    enum GameState{
        case waiting, pressed
    }
    enum FirstGame{
        case no, yes
    }
    
    //Button Functions
    
    //shuffle button function
    func shuffle(){
        gameState = GameState.pressed
        //        game.letters.shuffle()
        var arr : [String] = game.letters
        arr.remove(at: 0)
        arr.shuffle()
        game.letters = [game.yellowLetter] +  arr
        gameState = GameState.waiting
    }
    
    //new game button function
    func newGame(){
        gameState = GameState.pressed
        firstRound = FirstGame.no
        switch(preferences.numLetter){
        case ProblemSize.five:
            game.letterCount = 5
            break
        case ProblemSize.six:
            game.letterCount = 6
            break
        case ProblemSize.seven:
            game.letterCount = 7
            break
        }
        wordForming = []
        wordsFormed = []
        score = 0
        switch(preferences.language){
        case Language.english:
            game.wordsAllowed = Words.words
            break
        case Language.french:
            game.wordsAllowed = Words.frenchWords
            break
        }
        let newWord : [String] = generateValidWord(numLetters: game.letterCount)
        game.letters = newWord
        game.yellowLetter = newWord[0]
        game = ScrambleProblem(letters: game.letters, letterCount: game.letterCount, preferences: game.preferences, yellowLetter: game.yellowLetter, wordsAllowed: game.wordsAllowed)
        hints = Hints(totalWords: 0, totalPoints: 0, pangrams: 0, wordLengths: [:])
        calculateHints()
        gameState = GameState.waiting
    }
    
    //keeps track of if the word we are forming is empty so we can disable or enable the delete button
    var wordFormingEmpty : Bool = true
    
    //delete button function
    func delete(){
        gameState = GameState.pressed
        if(!wordForming.isEmpty){
            wordForming.removeLast()
            isValidWord()
        }
        if(wordForming.isEmpty){
            wordFormingEmpty = true
        }
        gameState = GameState.waiting
    }
    
    //submit button function
    func submit(){
        gameState = GameState.pressed
        let word = wordForming.joined()
        if(isValid){
            wordsFormed.append(word)
            wordForming.removeAll()
            updateScore(word: word)
            isValid = false
            wordFormingEmpty = true
        }
        gameState = GameState.waiting
    }
    
    //letter button function
    func letterPressed(letter : String){
        gameState = GameState.pressed
        wordForming.append(letter)
        isValidWord()
        wordFormingEmpty = false
        gameState = GameState.waiting
    }
    
    func calculateHints(){
        //call helper functions
        gameState = GameState.pressed
        var validWords : Int = 0
        var pangrams : Int = 0
        var points : Int = 0
        var wordsOfLengthDictionary = [Int : [String : Int]]()
        var firstLetter : String = ""
        for word in game.wordsAllowed {
            if(hintsValidWordCheck(word: word)){
                validWords += 1
                if(pangramCheck(word: word)){
                    pangrams += 1
                }
                points += hintsPossiblePoints(word: word)
                firstLetter = String(word.prefix(1))

                if var firstLetterDictionary = wordsOfLengthDictionary[word.count]{
                    if let temp = firstLetterDictionary[firstLetter]{
                        firstLetterDictionary[firstLetter] = temp + 1
                    }else{
                        firstLetterDictionary[firstLetter] = 1
                    }
                    wordsOfLengthDictionary[word.count] = firstLetterDictionary
                }else{
                    wordsOfLengthDictionary[word.count] = [firstLetter : 1]
                }
                 
            }
            
        }
        //sorts the dictionary keys and then creates a new dictionary with these sorted keys
        
        
        hints.totalWords = validWords
        hints.pangrams = pangrams
        hints.totalPoints = points
        hints.wordLengths = wordsOfLengthDictionary
        gameState = GameState.waiting
    }
    
    func getOffset(sides: Int, letter: String, size: CGSize) -> CGPoint {
        var position : CGPoint = CGPoint(x: 0, y: 0)
        var index : Int = 0
        //get index from letter
        for _ in game.letters {
            if(game.letters[index] == letter){
                break
            }
            index += 1
        }
        let frameWidth = size.width
        let frameHeight = size.height
        let center = CGPoint(x: frameWidth / 2, y: frameHeight / 2)
        
        switch(sides){
        case 5:
            if(index == 0){
                position = CGPoint(x: center.x, y: center.y)
            }else if(index == 1){
                position = CGPoint(x: center.x - 45, y: center.y + 45)
            }else if(index == 2){
                position = CGPoint(x: center.x - 45, y: center.y - 45)
            }else if(index == 3){
                position = CGPoint(x: center.x + 45, y: center.y + 45)
            }else{
                position = CGPoint(x: center.x + 45, y: center.y - 45)
            }
            break
        case 6:
            if(index == 0){
                position = CGPoint(x: center.x, y: center.y)
            }else if(index == 1){
                position = CGPoint(x: center.x - 30, y: center.y - 40)
            }else if(index == 2){
                position = CGPoint(x: center.x - 48, y: center.y  + 18)
            }else if(index == 3){
                position = CGPoint(x: center.x + 30, y: center.y - 40)
            }else if(index == 4){
                position = CGPoint(x: center.x + 48, y: center.y + 18)
            }else{
                position = CGPoint(x: center.x, y: center.y + 50)
            }
            break
        case 7:
            if(index == 0){
                position = CGPoint(x: center.x, y: center.y)
            }else if(index == 1){
                position = CGPoint(x: center.x, y: center.y + 50)
            }else if(index == 2){
                position = CGPoint(x: center.x, y: center.y - 50)
            }else if(index == 3){
                position = CGPoint(x: center.x + 45, y: center.y + 25)
            }else if(index == 4){
                position = CGPoint(x: center.x - 45, y: center.y + 25)
            }else if(index == 5){
                position = CGPoint(x: center.x + 45, y: center.y - 25)
            }else{
                position = CGPoint(x: center.x - 45, y: center.y - 25)
            }
            break
        default:
            break
        }
        
        return position
    }
    
    //Helper Functions
    
    //creates a valid word by using random numbers for the index of the words array. we use another helper function
    //which checks validity
    private func generateValidWord(numLetters: Int) -> [String]{
        var randNum = Int.random(in: 0..<game.wordsAllowed.count)
        var currentWord : String = game.wordsAllowed[randNum]
        
        while(!lettersValid(word: currentWord, num: numLetters)){
            randNum += 1
            currentWord = game.wordsAllowed[randNum]
        }
        let letters = Array(currentWord)
        //below line converts array of chars to strings
        let lettersAsStrings = letters.map{String($0)}
        //below line returns letters but not duplicates
        return Array(Set(lettersAsStrings))
    }
    
    //checks if the letters we want as the problem are valid (enough unique letters since we already made sure word is formed
    private func lettersValid(word: String, num: Int) -> Bool{
        var letters = Array(word)
        letters = Array(Set(letters))
        if(letters.count != num){
            return false
        }
        return true
    }
    
    var isValid : Bool = false
    
    //Checks if the word forming is a valid word to be submitted
    private func isValidWord(){
        isValid = false
        if(wordForming.count < 4){
            isValid = false
        }
        let word = wordForming.joined()
        if(game.wordsAllowed.contains(word) && !wordsFormed.contains(word) && word.contains(game.yellowLetter)){
            isValid = true
        }
    }
    
    private func hintsValidWordCheck(word: String) -> Bool{
        var tempWord = word
        if(tempWord.contains(game.yellowLetter)){
            for letter in game.letters{
                tempWord = tempWord.replacingOccurrences(of: letter, with: "")
            }
            if(tempWord.isEmpty){
                return true
            }
        }
        return false
    }
    
    private func pangramCheck(word: String) -> Bool {
        for letter in game.letters{
            if(!word.contains(letter)){
                return false
            }
        }
        return true
    }
    
    private func hintsPossiblePoints(word: String) -> Int{
        var wordScore : Int = 0
        if(word.count == 4){
            wordScore += 1
        }else{
            wordScore += word.count
            if(pangramCheck(word: word)){
                wordScore += 10
            }
        }
        return wordScore
    }
    
    func isFirstRound() -> Bool {
        if(firstRound == FirstGame.yes){
            return true
        }else{
            return false
        }
    }
    
    func isPentagon() -> Bool {
        if(game.letterCount == 6){
            return true
        }
        return false
    }
    
    func isSquare() -> Bool {
        if(game.letterCount == 5){
            return true
        }
        return false
    }
    
    
    //Used to calculate the score based on word submitted
    private func updateScore(word: String){
        if(word.count == 4){
            score += 1
        }else{
            score += word.count
            var allLetters : Bool = true
            for letter in game.letters{
                if(!word.contains(letter)){
                    allLetters = false
                }
            }
            if(allLetters){
                score += 10
            }
        }
    }
    
    
}
