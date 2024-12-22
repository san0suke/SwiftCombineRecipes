//
//  MockIngredientDAO.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 19/12/24.
//

import Foundation
import CoreData
@testable import CombineRecipes

class MockIngredientDAO: MockBaseDAO, IngredientDAOProtocol {
    
    var createInstanceCompletion: (() -> Ingredient)?
    var fetchAllCompletion: (() -> [Ingredient])?
    
    func createInstance() -> Ingredient {
        return createInstanceCompletion?() ?? Ingredient(entity: Ingredient.entity(), insertInto: nil)
    }
    
    func fetchAll() -> [Ingredient] {
        return fetchAllCompletion?() ?? []
    }
}
