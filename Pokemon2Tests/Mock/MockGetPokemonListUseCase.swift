//
//  File.swift
//  Pokemon2Tests
//
//  Created by William Moraes da Silva on 13/06/25.
//

import Foundation
@testable import Pokemon2

final class MockGetPokemonListUseCase: GetPokemonListUseCaseProtocol {
    
    var result: Result<[Pokemon], Error>!
    private(set) var executeCallCount = 0

    func execute(offset: Int, limit: Int) async throws -> [Pokemon] {        executeCallCount += 1
        return try result.get()
    }
}
