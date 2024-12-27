//
//  SelectIngredientViewModel.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 26/12/24.
//

import Foundation
import Combine

class SelectIngredientViewModel {
    
    private let ingredientsDAO: IngredientDAO
    private(set) var ingredients = CurrentValueSubject<[Ingredient], Never>([])
    private(set) var selectedIngredients = CurrentValueSubject<Set<Ingredient>, Never>([])
    
    init(selectedIngredients: [Ingredient],
         ingredientsDAO: IngredientDAO = IngredientDAO()) {
        self.selectedIngredients.send(Set(selectedIngredients))
        self.ingredientsDAO = ingredientsDAO
    }
    
    // MARK: - Fetch Ingredients
     func fetch() {
        ingredients.send(ingredientsDAO.fetchAll())
    }
    
    func contains(_ ingredient: Ingredient) -> Bool {
        return selectedIngredients.value.contains(ingredient)
    }
    
    func onRowPressed(_ ingredient: Ingredient) {
        if contains(ingredient) {
            remove(ingredient)
        } else {
            add(ingredient)
        }
    }
    
    private func add(_ ingredient: Ingredient) {
        var ingredients = selectedIngredients.value
        ingredients.insert(ingredient)
        selectedIngredients.send(ingredients)
    }
    
    private func remove(_ ingredient: Ingredient) {
        var ingredients = selectedIngredients.value
        ingredients.remove(ingredient)
        selectedIngredients.send(ingredients)
    }
}
