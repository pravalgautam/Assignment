//
//  CoreDataManager.swift
//  Assignment
//
//  Created by Praval Gautam on 14/02/25.
//
import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "FavoriteModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

    func savePokemon(pokemon: Pokemon) {
        let context = persistentContainer.viewContext
        let favoritePokemon = FavoriteItem(context: context)
        
        favoritePokemon.name = pokemon.name
        favoritePokemon.url = pokemon.imageURL

        do {
            try context.save()
            print("Pokémon saved successfully!")
        } catch {
            print("Error saving Pokémon: \(error)")
        }
    }

    func fetchAllFavoritePokemons() -> [FavoriteItem] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching favorite Pokémon: \(error)")
            return []
        }
    }

    func isPokemonFavorite(pokemon: Pokemon) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", pokemon.name)
        
        do {
            return try context.fetch(fetchRequest).count > 0
        } catch {
            return false
        }
    }

    func removePokemonFromFavorites(pokemon: Pokemon) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", pokemon.name)

        do {
            let favorites = try context.fetch(fetchRequest)
            for favorite in favorites {
                context.delete(favorite)
            }
            try context.save()
            print("Pokémon removed from favorites!")
        } catch {
            print("Error removing Pokémon: \(error)")
        }
    }
}
