//
//  PokeMonView.swift
//  Assignment
//
//  Created by Praval Gautam on 13/02/25.
//

import SwiftUI


struct PokemonGridView: View {
    @ObservedObject var viewModel = PokemonViewModel()
    @State private var showAlert = false
    @State private var favoritePokemons: Set<String> = []

    var body: some View {
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
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.white)
                                    .frame(height: 220)

                                VStack {
                                    if let imageURL = pokemon.imageURL, let url = URL(string: imageURL) {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                                .scaledToFit()
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
                .padding()
            }
        }
        .onAppear {
            loadFavorites()
            viewModel.fetchPokemons()
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

    // Load Favorite Pokémon from Core Data
    private func loadFavorites() {
        let favorites = CoreDataManager.shared.fetchAllFavoritePokemons()
        favoritePokemons = Set(favorites.map { $0.name ?? "" })
    }
}



struct PokemonDetailView: View {
    var pokemon: Pokemon
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            Color.orange.opacity(0.2).ignoresSafeArea(.all)
       
            VStack {
                Text(pokemon.name.capitalized)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .padding()
                Circle()
                    .fill(.white)
                    .frame(width: 250, height: 250)
                    .overlay{
                        if let imageURL = pokemon.imageURL, let url = URL(string: imageURL) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 250, height: 250)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                if let height = pokemon.height, let weight = pokemon.weight {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.orange)
                            Text("Height: \(height) decimetres")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Image(systemName: "arrow.down.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.orange)
                            Text("Weight: \(weight) hectograms")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)
                }

                
                Spacer()
            }
            .navigationBarItems(leading: Button(action: {
                          presentationMode.wrappedValue.dismiss() // This dismisses the detail view
                      }) {
                          HStack {
                              Circle()
                                  .fill(.white)
                                  .frame(width: 40, height: 40)
                                  .overlay{
                                      Image(systemName: "arrow.left") // Custom back button icon
                                          .foregroundColor(.orange)
                                  }.padding(.top)
                    
                          }
                      })
        }
        

    }
}

import SwiftUI

struct PokeMonView: View {
    @Binding var isNavigating: Bool
    @Environment(\.dismiss) var dismiss  // This will help in dismissing the view
    @State private var showFavorites = false
    @Environment(\.managedObjectContext) private var viewContext  // Use the provided Core Data context

    var body: some View {
        ZStack {
            Color.orange.opacity(0.2).ignoresSafeArea(.all)
            
            NavigationLink(
                destination: FavoritesView().navigationBarBackButtonHidden()
                    .environment(\.managedObjectContext, viewContext),  // Use the existing context
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
        
        .onChange(of: isNavigating) { newValue in
            if !newValue {
                dismiss()  // Go back to ContentView
            }
        }
    }
}

