//
//  Pokemon.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/14/24.
//

import Foundation

struct Pokemon : Codable, Identifiable {
    let id : Int
    let name : String
    let types : [PokemonType]
    let height : Double
    let weight : Double
    let weaknesses : [PokemonType]
    let prev_evolution : [Int]
    let next_evolution : [Int]
    var captured : Bool
    
    //create decode and encode
    enum CodingKeys : String, CodingKey {
        case id, name, types, height, weight, weaknesses, prev_evolution, next_evolution, captured
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.types = try container.decode([PokemonType].self, forKey: .types)
        self.height = try container.decode(Double.self, forKey: .height)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.weaknesses = try container.decode([PokemonType].self, forKey: .weaknesses)
        self.prev_evolution = try container.decodeIfPresent([Int].self, forKey: .prev_evolution) ?? []
        self.next_evolution = try container.decodeIfPresent([Int].self, forKey: .next_evolution) ?? []
        self.captured = try container.decodeIfPresent(Bool.self, forKey: .captured) ?? false
    }
    
    init(id: Int, name: String, types: [PokemonType], height: Double, weight: Double, weaknesses: [PokemonType], prev_evolution: [Int], next_evolution: [Int], captured: Bool) {
        self.id = id
        self.name = name
        self.types = types
        self.height = height
        self.weight = weight
        self.weaknesses = weaknesses
        self.prev_evolution = prev_evolution
        self.next_evolution = next_evolution
        self.captured = captured
    }
    
    static let mainDefault = Pokemon(id: 1, name: "Test", types: [PokemonType.dragon], height: 1.0, weight: 20.5, weaknesses: [PokemonType.bug], prev_evolution: [], next_evolution: [2, 3], captured: false)
    static let mainDefaultTwo = Pokemon(id: 2, name: "Test", types: [PokemonType.dragon], height: 3.0, weight: 20.5, weaknesses: [PokemonType.bug], prev_evolution: [], next_evolution: [2, 3], captured: false)
}

extension Pokemon{
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.captured, forKey: .captured)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.types, forKey: .types)
        try container.encode(self.height, forKey: .height)
        try container.encode(self.weight, forKey: .weight)
        try container.encode(self.weaknesses, forKey: .weaknesses)
        try container.encode(self.prev_evolution, forKey: .prev_evolution)
        try container.encode(self.next_evolution, forKey: .next_evolution)
    }
    
    func idFormattedToString() -> String{
        return String(format: "%03d", self.id)
    }
    
    mutating func toggleCaptured(){
        self.captured.toggle()
    }
}
