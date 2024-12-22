//
//  MockRecipeDAO.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 19/12/24.
//
//

import Foundation
import CoreData
@testable import CombineRecipes

class MockRecipeDAO: MockBaseDAO, RecipeDAOProtocol {
    
    var createInstanceCompletion: (() -> Recipe)?
    var fetchAllCompletion: (() -> [Recipe])?
    
    func createInstance() -> Recipe {
        return createInstanceCompletion?() ?? Recipe(entity: Recipe.entity(), insertInto: nil)
    }
    
    func fetchAll() -> [Recipe] {
        return fetchAllCompletion?() ?? []
    }
}
