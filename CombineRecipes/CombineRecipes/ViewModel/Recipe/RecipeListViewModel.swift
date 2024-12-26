//
//  RecipeListViewModel.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 26/12/24.
//

import CoreData
import Combine

protocol RecipeListViewModelProtocol {
    var recipes: CurrentValueSubject<[Recipe], Never> { get }
    func fetch()
    func delete(_ recipe: Recipe)
}

class RecipeListViewModel: RecipeListViewModelProtocol {

    private let recipeDAO: RecipeDAOProtocol

    var recipes = CurrentValueSubject<[Recipe], Never>([])

    private var cancellables = Set<AnyCancellable>()

    init(recipeDAO: RecipeDAOProtocol = RecipeDAO()) {
        self.recipeDAO = recipeDAO
    }

    // MARK: - Fetch Recipes
    func fetch() {
        recipes.send(recipeDAO.fetchAll())
    }

    // MARK: - Delete Recipe
    func delete(_ recipe: Recipe) {
        if recipeDAO.delete(recipe) {
            fetch()
        }
    }
}
