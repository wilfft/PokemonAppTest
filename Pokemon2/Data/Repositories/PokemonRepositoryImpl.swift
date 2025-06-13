//
//  Untitled.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

final class PokemonRepositoryImpl: PokemonRepository {
    private let remoteDataSource: PokemonRemoteDataSource
    
    init(remoteDataSource: PokemonRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getPokemonList(offset: Int, limit: Int) async throws -> [PokemonListItemDTO] {
        let listDTO = try await remoteDataSource.fetchPokemonList(offset: offset, limit: limit)
        return listDTO.results
    }
    
    func getPokemonDetail(id: Int) async throws -> Pokemon {
        let detailDTO = try await remoteDataSource.fetchPokemonDetail(id: id)
        return PokemonMapper.map(from: detailDTO)
    }
}
