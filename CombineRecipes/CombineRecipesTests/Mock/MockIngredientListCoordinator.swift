//
//  MockIngredientListCoordinator.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 29/12/24.
//

import Foundation
import Combine
@testable import CombineRecipes

class MockIngredientListCoordinator: IngredientListCoordinatorProtocol {

    // MARK: - Properties
    var navigationController: UINavigationControllerProtocol?

    // MARK: - Closures
    var presentIngredientFormCompletion: ((Ingredient?, @escaping () -> Void) -> Void)?

    // MARK: - Protocol Methods
    func presentIngredientForm(for ingredient: Ingredient?, completion: @escaping () -> Void) {
        presentIngredientFormCompletion?(ingredient, completion)
    }
}
