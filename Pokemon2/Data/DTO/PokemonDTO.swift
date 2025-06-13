//
//  File.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

import Foundation

struct PokemonDTO: Codable {
    let id: Int
    let name: String
    let sprites: SpritesDTO
}

struct SpritesDTO: Codable {
    let other: OtherSpritesDTO
}

struct OtherSpritesDTO: Codable {
    let home: HomeSpriteDTO
}

struct HomeSpriteDTO: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
