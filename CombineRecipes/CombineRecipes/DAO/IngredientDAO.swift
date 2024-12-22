//
//  IngredientDAO.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 14/12/24.
//

import CoreData

protocol IngredientDAOProtocol: BaseDAOProtocol {
    func createInstance() -> Ingredient
    func fetchAll() -> [Ingredient]
}

class IngredientDAO: BaseDAO, IngredientDAOProtocol {
    
    func createInstance() -> Ingredient {
        Ingredient(entity: Ingredient.entity(), insertInto: context)
    }

    // MARK: - Fetch
    func fetchAll() -> [Ingredient] {
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch Ingredients: \(error)")
            return []
        }
    }
}
