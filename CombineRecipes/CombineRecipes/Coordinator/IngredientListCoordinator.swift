//
//  IngredientListCoordinator.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 22/12/24.
//

import UIKit

protocol IngredientListCoordinatorProtocol {
    var navigationController: UINavigationControllerProtocol? { get set }
    func presentIngredientForm(for ingredient: Ingredient?, completion: @escaping () -> Void)
}

class IngredientListCoordinator: IngredientListCoordinatorProtocol {
    
    weak var navigationController: UINavigationControllerProtocol?
    
    func presentIngredientForm(for ingredient: Ingredient?, completion: @escaping () -> Void) {
//        let viewController = IngredientFormViewController(completion: completion, ingredient: ingredient)
//        navigationController?.presentMediumModal(viewController)
    }
}
