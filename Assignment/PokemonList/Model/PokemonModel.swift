//
//  PokemonModel.swift
//  Assignment
//
//  Created by Praval Gautam on 14/02/25.
//

import Foundation

struct Pokemon: Identifiable, Decodable {
    let id = UUID()
    let name: String
    let url: String
    var imageURL: String?
    var height: Int?
    var weight: Int?
}

struct PokemonResponse: Decodable {
    let results: [Pokemon]
}

struct PokemonDetail: Decodable {
    let name: String
    let sprites: Sprites
    let height: Int
    let weight: Int
}

struct Sprites: Decodable {
    let front_default: String?
}
