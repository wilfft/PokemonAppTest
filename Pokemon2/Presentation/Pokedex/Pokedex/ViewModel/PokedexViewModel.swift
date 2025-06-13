//
//  PokedexViewModel.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

import Foundation
import Combine

@MainActor
class PokedexViewModel: ObservableObject {
  @Published var pokemons: [Pokemon] = []
  @Published var viewState: ViewState = .loading
  
  private let getPokemonListUseCase: GetPokemonListUseCase
  private var currentOffset = 0
  private let limit = 15
  private var isLoadingMore = false
  private var canLoadMore = true
  
  init(getPokemonListUseCase: GetPokemonListUseCase) {
    self.getPokemonListUseCase = getPokemonListUseCase
  }
  
  func loadPokemon() async {
    guard !isLoadingMore && canLoadMore else { return }
    
    isLoadingMore = true
    if pokemons.isEmpty {
      viewState = .loading
    }
    
    do {
      let newPokemons = try await getPokemonListUseCase.execute(offset: currentOffset, limit: limit)
      if newPokemons.isEmpty || pokemons.count + newPokemons.count >= getPokemonListUseCase.pokemonLimit {
        canLoadMore = false
      }
      
      pokemons.append(contentsOf: newPokemons)
      currentOffset += limit
      viewState = pokemons.isEmpty ? .empty : .content
      
    } catch {
      viewState = .error(message: "Failed to load Pokémon. Please try again.")
    }
    
    isLoadingMore = false
  }
  
  func loadMorePokemonIfNeeded(currentItem: Pokemon?) {
    guard let currentItem = currentItem else {
      return
    }
    
    let thresholdIndex = pokemons.index(pokemons.endIndex, offsetBy: -5)
    if pokemons.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex {
      Task {
        await loadPokemon()
      }
    }
  }
}
