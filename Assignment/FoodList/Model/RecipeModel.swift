//
//  RecipeModel.swift
//  Assignment
//
//  Created by Praval Gautam on 14/02/25.
//

import Foundation

struct RecipeResponse: Decodable {
    let meals: [Recipe]
}

struct Recipe: Identifiable, Equatable, Decodable {
    let strMeal: String
    let strMealThumb: String
    let strInstructions: String
    
    var id: Int {
        return Int(strMealThumb.hashValue)
    }
    
    static func ==(lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }
}
