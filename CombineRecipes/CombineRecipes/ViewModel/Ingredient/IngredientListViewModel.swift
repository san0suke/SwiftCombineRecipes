//
//  IngredientListViewModel.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 22/12/24.
//

import CoreData
import Combine

protocol IngredientListViewModelProtocol {
    var ingredients: CurrentValueSubject<[Ingredient], Never> { get }
    func fetch()
    func delete(_ ingredient: Ingredient)
}

class IngredientListViewModel: IngredientListViewModelProtocol {

    private let ingredientDAO: IngredientDAOProtocol

    var ingredients = CurrentValueSubject<[Ingredient], Never>([])

    private var cancellables = Set<AnyCancellable>()

    init(ingredientDAO: IngredientDAOProtocol = IngredientDAO()) {
        self.ingredientDAO = ingredientDAO
    }

    // MARK: - Fetch Ingredients
    func fetch() {
        ingredients.send(ingredientDAO.fetchAll())
    }

    // MARK: - Delete Ingredient
    func delete(_ ingredient: Ingredient) {
        if ingredientDAO.delete(ingredient) {
            fetch()
        }
    }
}
