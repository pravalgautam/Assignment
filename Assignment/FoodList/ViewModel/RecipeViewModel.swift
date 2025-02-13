//
//  RecipeViewModel.swift
//  Assignment
//
//  Created by Praval Gautam on 13/02/25.
//

import Combine
import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipe: Recipe?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()
    
    
    private let url = URL(string: "https://www.themealdb.com/api/json/v1/1/random.php")!
    
    func fetchRecipe() {
        isLoading = true
        errorMessage = nil
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: RecipeResponse.self, decoder: JSONDecoder())
            .map { $0.meals.first }
            .replaceError(with: nil)
            .sink { [weak self] recipe in
                self?.isLoading = false
                self?.recipe = recipe
            }
            .store(in: &cancellables)
    }
}

