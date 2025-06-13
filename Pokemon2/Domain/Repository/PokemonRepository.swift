//
//  PokemonRepository.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

protocol PokemonRepository {
    func getPokemonList(offset: Int, limit: Int) async throws -> [PokemonListItemDTO]
    func getPokemonDetail(id: Int) async throws -> Pokemon
}
