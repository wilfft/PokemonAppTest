//
//  ViewState.swift
//  Pokemon2
//
//  Created by William Moraes da Silva on 13/06/25.
//

import Foundation

enum ViewState: Equatable {
    case loading
    case content
    case error(message: String)
    case empty
}
