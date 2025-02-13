//
//  PokemonDetailVideo.swift
//  Assignment
//
//  Created by Praval Gautam on 14/02/25.
//

import SwiftUI

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
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 40, height: 40)
                        .overlay{
                            Image(systemName: "arrow.left")
                                .foregroundColor(.orange)
                        }.padding(.top)
                    
                }
            })
        }
        
    }
}

