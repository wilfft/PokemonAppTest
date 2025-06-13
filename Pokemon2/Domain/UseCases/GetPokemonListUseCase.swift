//
//  GetPokemonListUseCase.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

import Foundation

class GetPokemonListUseCase {
    private let repository: PokemonRepository
    private let pokemonLimit = 151
  
    init(repository: PokemonRepository) {
        self.repository = repository
    }
    
    // Extracts Pokémon ID from the URL (e.g. ".../pokemon/1/")
    private func extractId(from url: String) -> Int? {
        let components = url.split(separator: "/").compactMap { Int($0) }
        return components.first
    }

    func execute(offset: Int, limit: Int) async throws -> [Pokemon] {
        let listItems = try await repository.getPokemonList(offset: offset, limit: limit)
        
        let pokemons = try await withThrowingTaskGroup(of: Pokemon.self) { group in
            var results: [Pokemon] = []
            
            for item in listItems {
                if let id = extractId(from: item.url), id <= pokemonLimit {
                    group.addTask {
                        return try await self.repository.getPokemonDetail(id: id)
                    }
                }
            }
            
            for try await pokemon in group {
                results.append(pokemon)
            }
            
            return results.sorted { $0.id < $1.id } // Ensure order
        }
        
        return pokemons
    }
}
