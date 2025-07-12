//
//  CacheManager.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 12/07/25.
//

import Foundation

class CacheManager {

    static let shared = CacheManager()

    private let fileName = "pokemon_cache.json"

    private var fileURL: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0].appendingPathComponent(fileName)
    }

    func savePokemons(_ pokemons: [PokemonListItem]) {
        do {
            let data = try JSONEncoder().encode(pokemons)
            try data.write(to: fileURL)
            print("Cache saved!")
        } catch {
            print("Error saving cache: \(error)")
        }
    }

    func loadPokemons() -> [PokemonListItem] {
        do {
            let data = try Data(contentsOf: fileURL)
            let pokemons = try JSONDecoder().decode([PokemonListItem].self, from: data)
            print("Cache loaded!")
            return pokemons
        } catch {
            print("No cache found or error loading: \(error)")
            return []
        }
    }
}
