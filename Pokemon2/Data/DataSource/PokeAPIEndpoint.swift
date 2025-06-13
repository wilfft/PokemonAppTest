//
//  PokeAPIEndpoint.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

import Foundation

enum PokeAPIEndpoint: Endpoint {
  case getPokemonList(offset: Int, limit: Int)
  case getPokemonDetail(id: Int)
  
  var host: String {
    return "pokeapi.co"
  }
  
  var method: HTTPMethod {
    switch self {
    default:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .getPokemonList:
      return "/api/v2/pokemon"
    case .getPokemonDetail(let id):
      return "/api/v2/pokemon/\(id)"
    }
  }
  
  var queryItems: [URLQueryItem]? {
    switch self {
    case .getPokemonList(let offset, let limit):
      return [
        URLQueryItem(name: "offset", value: "\(offset)"),
        URLQueryItem(name: "limit", value: "\(limit)")
      ]
    case .getPokemonDetail:
      return nil
    }
  }
}
