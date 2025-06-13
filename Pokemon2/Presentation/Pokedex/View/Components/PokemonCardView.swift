//
//  PokemonCardView.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

import SwiftUI

struct PokemonCardView: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            AsyncImageView(url: URL(string: pokemon.imageUrl))
                .frame(width: 80, height: 80)
            
            Text(pokemon.name)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text(String(format: "#%03d", pokemon.id))
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
    }
}
