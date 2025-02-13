//
//  PokeMonView.swift
//  Assignment
//
//  Created by Praval Gautam on 13/02/25.
//

import SwiftUI

struct PokeMonView: View {
    @Binding var isNavigating: Bool
    @Environment(\.dismiss) var dismiss
    @State private var showFavorites = false
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        ZStack {
            Color.orange.opacity(0.2).ignoresSafeArea(.all)
            
            NavigationLink(
                destination: FavoritesView().navigationBarBackButtonHidden()
                    .environment(\.managedObjectContext, viewContext),
                isActive: $showFavorites
            ) {
                EmptyView()
            }
            
            VStack {
                VStack {
                    Toggle(isOn: $isNavigating) {
                        Button(action: {
                            showFavorites.toggle()
                        }) {
                            Text("Show Favorites")
                                .font(.headline)
                                .padding(8)
                                .background(Color.pink)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .black))
                    .padding()
                }
                
                PokemonGridView()
            }
            Spacer()
        }
        .onAppear{
            PokemonGridView()
        }
        .onChange(of: isNavigating) { newValue in
            if !newValue {
                dismiss() 
            }
        }
    }
}

struct PokemonGridView: View {
    @StateObject var viewModel = PokemonViewModel() // Changed from @ObservedObject to @StateObject
    @State private var showAlert = false
    @State private var favoritePokemons: Set<String> = []

    var body: some View {
        NavigationView {
            ZStack {
                Color.orange.opacity(0.2).ignoresSafeArea(.all)
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                        } else if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                                .onTapGesture {
                                    showAlert = true
                                }
                        } else {
                            ForEach(viewModel.pokemons) { pokemon in
                                NavigationLink(destination: PokemonDetailView(pokemon: pokemon).navigationBarBackButtonHidden()) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.white)
                                            .frame(height: 220)

                                        VStack {
                                            if let imageURL = pokemon.imageURL, let url = URL(string: imageURL) {
                                                AsyncImage(url: url) { image in
                                                    image.resizable()
                                                        .scaledToFit()
                                                        .frame(height: 100)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                            }

                                            Text(pokemon.name.capitalized)
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.orange.opacity(0.6))
                                        }

                                        // Favorite Heart Icon
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Button(action: {
                                                    toggleFavorite(pokemon: pokemon)
                                                }) {
                                                    Image(systemName: favoritePokemons.contains(pokemon.name) ? "heart.fill" : "heart")
                                                        .foregroundColor(.red)
                                                        .padding(10)
                                                }
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .onAppear {
                loadFavorites()
                viewModel.fetchPokemons()
            }
        }
    }

    // Toggle Pokémon Favorite Status
    private func toggleFavorite(pokemon: Pokemon) {
        if favoritePokemons.contains(pokemon.name) {
            CoreDataManager.shared.removePokemonFromFavorites(pokemon: pokemon)
            favoritePokemons.remove(pokemon.name)
        } else {
            CoreDataManager.shared.savePokemon(pokemon: pokemon)
            favoritePokemons.insert(pokemon.name)
        }
    }

    // Load favorite Pokémon
    private func loadFavorites() {
        let favorites = CoreDataManager.shared.fetchAllFavoritePokemons()
        favoritePokemons = Set(favorites.map { $0.name ?? "" })
    }
}


