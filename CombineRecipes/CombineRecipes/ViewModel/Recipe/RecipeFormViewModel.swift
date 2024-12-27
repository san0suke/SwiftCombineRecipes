//
//  RecipeFormViewModel.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 26/12/24.
//

import Foundation
import Combine

protocol RecipeFormViewModelProtocol: AnyObject {
    var viewState: RecipeFormViewModel.ViewState { get }
    var isEditing: Bool { get }
    var recipeSubject: CurrentValueSubject<Recipe?, Never> { get }
    
    func updateSelectedIngredients(_ ingredients: [Ingredient])
    func save() -> Bool
}

class RecipeFormViewModel: RecipeFormViewModelProtocol {
    
    class ViewState {
        @Published var isSaveButtonEnabled: Bool = false
        @Published var recipeName: String = ""
        @Published var selectedIngredients: [Ingredient] = []
    }
    
    private(set) var viewState = ViewState()
    
    private let recipeDAO: RecipeDAOProtocol
    private(set) var recipeSubject = CurrentValueSubject<Recipe?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Outputs
    private(set) var isEditing: Bool = false
    
    // MARK: - Initialization
    init(recipeDAO: RecipeDAOProtocol = RecipeDAO()) {
        self.recipeDAO = recipeDAO
        
        recipeSubject
            .sink { [weak self] recipe in
                guard let self = self else { return }
                
                self.isEditing = recipe != nil
                
                if let existingRecipe = recipe {
                    self.viewState.recipeName = existingRecipe.name ?? ""
                    self.updateSelectedIngredients(existingRecipe.ingredients?.allObjects as? [Ingredient] ?? [])
                }
            }
            .store(in: &cancellables)
        
        viewState.$recipeName
            .map { !$0.isEmpty }
            .removeDuplicates()
            .assign(to: &viewState.$isSaveButtonEnabled)
    }
    
    func updateSelectedIngredients(_ ingredients: [Ingredient]) {
        viewState.selectedIngredients = ingredients.sorted { $0.name ?? "" < $1.name ?? "" }
    }
    
    // MARK: - Create or Update Recipe
    func save() -> Bool {
        let recipe = recipeSubject.value ?? recipeDAO.createInstance()
        recipe.name = viewState.recipeName
        recipe.ingredients = NSSet(array: viewState.selectedIngredients)
        
        return recipeDAO.saveContext()
    }
}
