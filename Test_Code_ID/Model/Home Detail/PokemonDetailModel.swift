//
//  HomeDetailModel.swift
//  Test_Code_ID
//
//  Created by Devin Maleke on 11/07/25.
//

import Foundation

struct PokemonDetailModel: Codable {
    let id: Int
    let name: String
    let abilities: [Ability]
    let sprites: Sprites
}

struct Ability: Codable {
    let ability: AbilityInfo
}

struct AbilityInfo: Codable{
    let name: String
}

struct Sprites: Codable {
    let front_default: String?
}
