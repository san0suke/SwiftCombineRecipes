//
//  RecipeFormCoordinator.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 26/12/24.
//

import UIKit

protocol RecipeFormCoordinatorProtocol {
    var navigationController: UINavigationControllerProtocol? { get set }
    func presentSelectIngredient(with ingredients: [Ingredient]?, completion: @escaping ([Ingredient]) -> Void)
}

class RecipeFormCoordinator: RecipeFormCoordinatorProtocol {
    
    weak var navigationController: UINavigationControllerProtocol?
    
    func presentSelectIngredient(with ingredients: [Ingredient]?, completion: @escaping ([Ingredient]) -> Void) {
        let viewController = SelectIngredientViewController(selectedIngredients: ingredients ?? []) { ingredients in
            completion(ingredients)
        }
        
        navigationController?.presentMediumModal(viewController)
    }
}
