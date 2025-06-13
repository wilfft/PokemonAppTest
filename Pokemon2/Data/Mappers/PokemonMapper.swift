//
//  PokemonMapper.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

struct PokemonMapper {
    static func map(from dto: PokemonDTO) -> Pokemon {
        return Pokemon(
            id: dto.id,
            name: dto.name.capitalized,
            imageUrl: dto.sprites.other.home.frontDefault
        )
    }
}
