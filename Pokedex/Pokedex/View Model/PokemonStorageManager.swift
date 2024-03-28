//
//  PokemonStorageManager.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/15/24.
//

import Foundation

class PokemonManager<model: Codable>{
    let modelData : model?
    init(){
        let fileURL = URL.documentsDirectory.appendingPathComponent("pokedex.json")
        if(FileManager.default.fileExists(atPath: fileURL.path)){
            do{
                let content = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                modelData = try decoder.decode(model.self, from: content)
            }catch{
                print(error)
                modelData = nil
            }
            return
        }
        
        let bundle = Bundle.main
        let url = bundle.url(forResource: "pokedex", withExtension: "json")
        
        guard let url = url else {modelData = nil; return}
        do{
            let content = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            modelData = try decoder.decode(model.self, from: content)
        }catch{
            print(error)
            modelData = nil
        }
    }
    
    func save(pokemon: [Pokemon]){
        let encoder = JSONEncoder()
        let url = URL.documentsDirectory.appendingPathComponent("pokedex.json")
        do{
            let data = try encoder.encode(pokemon)
            try data.write(to: url)
        }catch{
            print(error)
        }
    }
}
