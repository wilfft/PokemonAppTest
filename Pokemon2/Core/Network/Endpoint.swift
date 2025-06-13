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
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }
  
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
