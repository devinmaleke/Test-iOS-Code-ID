//
//  HomeDetailModel.swift
//  Test_Code_ID
//
//  Created by Samir iOS on 11/07/25.
//

import Foundation

struct PokemonDetailModel: Decodable {
    let id: Int
    let name: String
    let abilities: [Ability]

    struct Ability: Decodable {
        let ability: AbilityInfo

        struct AbilityInfo: Decodable {
            let name: String
        }
    }
}
