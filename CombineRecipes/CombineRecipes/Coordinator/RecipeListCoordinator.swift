//
//  RecipeListCoordinator.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 26/12/24.
//

import UIKit

protocol RecipeListCoordinatorProtocol {
    var navigationController: UINavigationControllerProtocol? { get set }
    func presentRecipeForm(for recipe: Recipe?, completion: @escaping () -> Void)
}

class RecipeListCoordinator: RecipeListCoordinatorProtocol {
    
    weak var navigationController: UINavigationControllerProtocol?
    
    func presentRecipeForm(for recipe: Recipe?, completion: @escaping () -> Void) {
//        let viewController = RecipeFormViewController(completion: completion, ingredient: ingredient)
//        navigationController?.presentMediumModal(viewController)
    }
}
