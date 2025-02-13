//
//  PokemonViewModel.swift
//  Assignment
//
//  Created by Praval Gautam on 13/02/25.
//

import Foundation
import Combine

class PokemonViewModel: ObservableObject {
    @Published var pokemons: [Pokemon] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPokemons() {
        self.isLoading = true
        self.errorMessage = nil
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=10")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PokemonResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .flatMap { pokemons in
                // Fetch detailed data (including image URLs) for each Pokémon
                Publishers.MergeMany(pokemons.map { pokemon in
                    self.fetchPokemonDetails(for: pokemon)
                })
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
                self.isLoading = false
            }, receiveValue: { pokemon in
                self.pokemons.append(pokemon)
                
                // Print fetched data for debugging
                if let imageURL = pokemon.imageURL {
                    print("Name: \(pokemon.name), Image URL: \(imageURL), Height: \(pokemon.height ?? 0), Weight: \(pokemon.weight ?? 0)")
                } else {
                    print("Name: \(pokemon.name), No image URL found")
                }
            })
            .store(in: &cancellables)
    }
    
    private func fetchPokemonDetails(for pokemon: Pokemon) -> AnyPublisher<Pokemon, Error> {
        let url = URL(string: pokemon.url)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: PokemonDetail.self, decoder: JSONDecoder())
            .map { detail in
                var updatedPokemon = pokemon
                updatedPokemon.imageURL = detail.sprites.front_default // Assuming sprites is available here
                updatedPokemon.height = detail.height
                updatedPokemon.weight = detail.weight

                return updatedPokemon
            }
            .eraseToAnyPublisher()
    }
}

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
