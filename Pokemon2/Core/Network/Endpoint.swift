//
//  Endpoint.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//
import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get } // <-- Alterado de String para HTTPMethod
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get } // <-- Adicionado para métodos como POST/PUT
    var headers: [String: String]? { get } // <-- Adicionado para headers customizados
}

extension Endpoint {
    var scheme: String {
        return "https"
    }
    
    // O método padrão agora é o nosso enum .get
    var method: HTTPMethod {
        return .get
    }
    
    var body: [String: Any]? {
        return nil
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}
