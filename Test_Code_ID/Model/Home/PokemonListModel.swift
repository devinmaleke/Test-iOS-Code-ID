//
//  PokemonListModel.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 11/07/25.
//

import Foundation

struct PokemonListModel: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable {
    let name: String
    let url: String
}
