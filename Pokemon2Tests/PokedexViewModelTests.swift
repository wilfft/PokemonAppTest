//
//  Pokemon2Tests.swift
//  Pokemon2Tests
//
//  Created by William Moraes da Silva on 13/06/25.
//

import XCTest
@testable import Pokemon2

@MainActor
final class PokedexViewModelTests: XCTestCase {
  
  var viewModel: PokedexViewModel!
  var mockUseCase: MockGetPokemonListUseCase!
  
  override func setUp() {
    super.setUp()
    mockUseCase = MockGetPokemonListUseCase()
    viewModel = PokedexViewModel(getPokemonListUseCase: mockUseCase)
  }
  
  override func tearDown() {
    viewModel = nil
    mockUseCase = nil
    super.tearDown()
  }
  
  func testLoadPokemon_WhenUseCaseSucceeds_ShouldUpdateStateToContentAndPokemons() async {
    // Arrange
    let mockPokemons = [Pokemon(id: 1, name: "Bulbasaur", imageUrl: "url1")]
    mockUseCase.result = .success(mockPokemons)
    
    XCTAssertEqual(viewModel.viewState, .loading, "O estado inicial deveria ser .loading")
    
    // Act
    await viewModel.loadPokemon()
    
    // Assert
    XCTAssertEqual(viewModel.viewState, .content, "O estado deveria mudar para .content após o sucesso")
    XCTAssertEqual(viewModel.pokemons.count, 1, "Deveria haver 1 Pokémon na lista")
    XCTAssertEqual(viewModel.pokemons.first?.name, "Bulbasaur")
  }
  
  func testLoadPokemon_WhenUseCaseFails_ShouldUpdateStateToError() async {
    // Arrange
    let expectedError = URLError(.notConnectedToInternet)
    mockUseCase.result = .failure(expectedError)
    
    XCTAssertEqual(viewModel.viewState, .loading)
    
    // Act
    await viewModel.loadPokemon()
    
    // Assert
    XCTAssertEqual(viewModel.viewState, .error(message: "Failed to load Pokémon. Please try again."), "O estado deveria mudar para .error após a falha")
    XCTAssertTrue(viewModel.pokemons.isEmpty, "A lista de Pokémon deveria estar vazia em caso de erro")
  }
  
  func testLoadPokemon_WhenUseCaseSucceedsWithEmptyList_ShouldUpdateStateToEmpty() async {
    // Arrange
    mockUseCase.result = .success([])
    
    XCTAssertEqual(viewModel.viewState, .loading)
    
    // Assert
    await viewModel.loadPokemon()
    
    // Assert
    XCTAssertEqual(viewModel.viewState, .empty, "O estado deveria mudar para .empty se a lista retornada for vazia")
    XCTAssertTrue(viewModel.pokemons.isEmpty, "A lista de Pokémon deveria estar vazia")
  }
}
