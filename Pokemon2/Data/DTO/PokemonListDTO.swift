//
//  PokemonListDTO.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

import Foundation

struct PokemonListDTO: Codable {
    let results: [PokemonListItemDTO]
}

struct PokemonListItemDTO: Codable {
    let name: String
    let url: String
}
