//
//  PokemonRemoteDataSource.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

final class PokemonRemoteDataSource {
    private let networkService: NetworkService
    
    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }

    func fetchPokemonList(offset: Int, limit: Int) async throws -> PokemonListDTO {
        let endpoint = PokeAPIEndpoint.getPokemonList(offset: offset, limit: limit)
        return try await networkService.request(endpoint: endpoint)
    }
    
    func fetchPokemonDetail(id: Int) async throws -> PokemonDTO {
        let endpoint = PokeAPIEndpoint.getPokemonDetail(id: id)
        return try await networkService.request(endpoint: endpoint)
    }
}
