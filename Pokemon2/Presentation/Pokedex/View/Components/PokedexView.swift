//
//  PokedexView.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

import SwiftUI

struct PokedexView: View {
    @StateObject private var viewModel: PokedexViewModel
    
    init(viewModel: PokedexViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Content
                ZStack {
                    Color(.systemGray6).edgesIgnoringSafeArea(.bottom)
                    
                    switch viewModel.viewState {
                    case .loading:
                        ProgressView("Loading Pokédex...")
                    case .error(let message):
                        Text(message)
                            .padding()
                            .multilineTextAlignment(.center)
                    case .empty:
                        Text("No Pokémon found.")
                    case .content:
                        pokemonGridView
                    }
                }
            }
            .task {
                if viewModel.pokemons.isEmpty {
                    await viewModel.loadPokemon()
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack {
            HStack {
                Text("Pokédex")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
        }
        .padding(.bottom)
        .background(Color.red)
    }
    
    private var pokemonGridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.pokemons) { pokemon in
                    PokemonCardView(pokemon: pokemon)
                        .onAppear {
                            viewModel.loadMorePokemonIfNeeded(currentItem: pokemon)
                        }
                }
            }
            .padding()
        }
    }
}
