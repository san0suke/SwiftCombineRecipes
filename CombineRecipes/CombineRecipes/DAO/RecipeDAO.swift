//
//  RecipeDAO.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import CoreData

protocol RecipeDAOProtocol: BaseDAOProtocol {
    func createInstance() -> Recipe
    func fetchAll() -> [Recipe]
}

class RecipeDAO: BaseDAO, RecipeDAOProtocol {
    
    func createInstance() -> Recipe {
        Recipe(entity: Recipe.entity(), insertInto: context)
    }
    
    // MARK: - Fetch All
    func fetchAll() -> [Recipe] {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch Recipes: \(error)")
            return []
        }
    }
}
