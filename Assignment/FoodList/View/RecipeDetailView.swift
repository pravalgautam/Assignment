//
//  RecipeDetailView.swift
//  Assignment
//
//  Created by Praval Gautam on 14/02/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    AsyncImage(url: URL(string: recipe.strMealThumb)) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    } placeholder: {
                        ProgressView()
                    }
                    Spacer()
                }
                Text(recipe.strMeal)
                    .font(.largeTitle)
                    .bold()
                
                Text(recipe.strInstructions)
                    .font(.body)
                    .padding(.top, 10)
            }
            .padding()
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

