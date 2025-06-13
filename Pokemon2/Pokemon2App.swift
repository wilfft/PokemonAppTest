//
//  Pokemon2App.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

import SwiftUI

@main
struct Pokemon2App: App {
  @StateObject private var router = Router()
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
      // 2. Envolva a view raiz com o NavigationStack e passe o path do router
      NavigationStack(path: $router.path) {
        // 3. A view raiz precisa de uma forma de construir as outras telas (destinos)
        PokedexView(viewModel: pokedexViewModel)
          .navigationDestination(for: Route.self) { route in
            // Aqui é onde o "mágico" do roteamento acontece
            build(route: route)
          }
      }
      .environmentObject(router) // 4. Injete o router no ambiente do SwiftUI
    }
  }
  
  @ViewBuilder
     func build(route: Route) -> some View {
         switch route {
         case .pokedex:
             PokedexView(viewModel: pokedexViewModel)
         case .pokemonDetail:
           Text("to be Implemented")
         }
     }
}
