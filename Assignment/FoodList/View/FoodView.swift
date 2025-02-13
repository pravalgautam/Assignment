//
//  FoodView.swift
//  Assignment
//
//  Created by Praval Gautam on 13/02/25.
//
import SwiftUI

struct FoodView: View {
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var isSwipedLeft = false
    @State private var isSwipedRight = false
    @State private var isSaved = false
    @StateObject private var viewModel = RecipeViewModel()
    @State private var showRecipeDetails = false
    
    var body: some View {
        ZStack {
            Image("Back")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack {
                    Text("Food Matters")
                        .bold()
                        .font(.title)
                        .padding(.top, 50)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Card View with swipe gesture
                    ZStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                        } else if let recipe = viewModel.recipe {
                            
                            Rectangle()
                                .fill(Color.pink.opacity(0.2))
                                .cornerRadius(20)
                                .shadow(radius: 10)
                                .frame(width: 320, height: 460)
                                .overlay(
                                    VStack {
                                        VStack {
                                            AsyncImage(url: URL(string: recipe.strMealThumb)) { image in
                                                image.resizable()
                                                    .scaledToFit()
                                                    .frame(width: 250, height: 250)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                        .frame(width: 250, height: 250)
                                        .cornerRadius(12)
                                        HStack{
                                            Text(recipe.strMeal)
                                                .font(.title2)
                                                .bold()
                                            
                                            
                                            Button(action: {
                                                isSaved.toggle()
                                                
                                                if isSaved {
                                                    saveRecipeToCoreData(recipe: recipe)
                                                }
                                            }) {
                                                Image(systemName: isSaved ? "heart.fill" : "heart")
                                                    .font(.title)
                                                    .foregroundColor(isSaved ? .red : .gray)
                                                    .padding(.top,10)
                                            }
                                        }
                                        
                                        Button(action: {
                                            showRecipeDetails = true
                                        }) {
                                            Text("See Recipe")
                                                .font(.headline)
                                                .padding()
                                                .background(Color.pink)
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                        .padding(.top, 20)
                                        .sheet(isPresented: $showRecipeDetails) {
                                            RecipeDetailView(recipe: recipe)
                                        }
                                    }
                                )
                            
                                .offset(x: offset.width, y: offset.height)
                                .rotationEffect(.degrees(rotation))
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            offset = value.translation
                                            rotation = Double(offset.width / 20)
                                        }
                                        .onEnded { value in
                                            if offset.width < -150 {
                                                isSwipedLeft = true
                                                viewModel.fetchRecipe()
                                            } else if offset.width > 150 {
                                                isSwipedRight = true
                                                viewModel.fetchRecipe()
                                            }
                                            withAnimation {
                                                offset = .zero
                                                rotation = 0
                                            }
                                        }
                                )
                        }
                    }
                    
                    Spacer()
                }
                .onAppear {
                    viewModel.fetchRecipe()
                }
                .onChange(of: viewModel.recipe) { newRecipe in
                    if newRecipe != nil {
                        isSaved = false
                    }
                }
            }
        }
    }
    // saving data to core data
    private func saveRecipeToCoreData(recipe: Recipe) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let foodItem = FavoriteItem(context: context)
        
        foodItem.name = recipe.strMeal
        foodItem.url = recipe.strMealThumb
        
        do {
            try context.save()
            print("Recipe saved successfully!")
        } catch {
            print("Error saving recipe: \(error)")
        }
    }
}


#Preview {
    FoodView()
}
