//
//  PokedexViewModel.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

import Foundation
import Combine

@MainActor
final class PokedexViewModel: ObservableObject {
  @Published var pokemons: [Pokemon] = []
  @Published var viewState: ViewState = .loading
  @Published var isFetchingMore: Bool = false
  
  private let getPokemonListUseCase: GetPokemonListUseCaseProtocol
  private let listPageLimit = AppConfig.pokemonListPageLimit
  private let maxPokemon = AppConfig.maxPokemon
  private var currentOffset = 0
  private var isLoadingMore = false
  private var canLoadMore = true
  
  init(getPokemonListUseCase: GetPokemonListUseCaseProtocol) {
         self.getPokemonListUseCase = getPokemonListUseCase
     }
  
  func loadPokemon() async {
    guard !isLoadingMore && canLoadMore else { return }
    
    isLoadingMore = true
    
    if !pokemons.isEmpty {
      isFetchingMore = true
    } else {
      viewState = .loading
    }
    
    do {
      let newPokemons = try await getPokemonListUseCase.execute(offset: currentOffset, limit: listPageLimit)
      if newPokemons.isEmpty || pokemons.count + newPokemons.count >= maxPokemon {
        canLoadMore = false
      }
      
      pokemons.append(contentsOf: newPokemons)
      currentOffset += listPageLimit
      viewState = pokemons.isEmpty ? .empty : .content
      
    } catch {
      viewState = .error(message: "Failed to load Pokémon. Please try again.")
    }
    
    isLoadingMore = false
    isFetchingMore = false
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
