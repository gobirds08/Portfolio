//
//  PokedexManager.swift
//  Pokedex
//
//  Created by Brendan Kenney on 3/15/24.
//

import Foundation

class PokedexManager : ObservableObject{
    
    let pokemonStorage : PokemonManager = PokemonManager<[Pokemon]>()
    
    @Published var pokemon : [Pokemon] = []
    @Published var pokemonList : [Pokemon] = []
    
    var capturedPokemon : [Pokemon] {pokemon.filter{$0.captured}}
    
    init(){
        print(pokemonStorage.modelData ?? "nil")
        pokemon = pokemonStorage.modelData ?? []
        pokemonList = pokemon
        print(pokemon)
    }
    
    func setListNoFilter(){
        pokemonList = pokemon
    }
    
    func changeList(type: PokemonType){
        pokemonList = getPokemonFromType(type: type)
    }
    
    func getPokemonFromType(type: PokemonType) -> [Pokemon]{
        let pokemon : [Pokemon] = pokemon.filter{$0.types.contains(type)}
        return pokemon
    }
    
    func getPokemonFromID(id: Int) -> Pokemon{
        let new : Pokemon = pokemon.first(where: {$0.id == id}) ?? Pokemon.mainDefault
        return new
    }
    
    func getIndexFromPokemon(new: Pokemon) -> Int{
        return pokemon.firstIndex(where: {$0.id == new.id}) ?? -1
    }
    
    func save(){
        pokemonStorage.save(pokemon: pokemon)
    }
}
