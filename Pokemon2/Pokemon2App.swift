//
//  Pokemon2App.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

import SwiftUI

@main
struct Pokemon2App: App {
  @StateObject private var pokedexViewModel: PokedexViewModel
  
  init() {
    // creating Data Layer
    let remoteDataSource = PokemonRemoteDataSource()
    let pokemonRepository: PokemonRepository = PokemonRepositoryImpl(remoteDataSource: remoteDataSource)
    
    // creating Data Layer (Use Case)
    let getPokemonListUseCase = GetPokemonListUseCase(repository: pokemonRepository)
    
    _pokedexViewModel = StateObject(wrappedValue: PokedexViewModel(getPokemonListUseCase: getPokemonListUseCase))
  }
  
  var body: some Scene {
    WindowGroup {
      PokedexView(viewModel: pokedexViewModel)
    }
  }
}
