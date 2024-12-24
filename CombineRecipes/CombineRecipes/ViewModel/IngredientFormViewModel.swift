//
//  IngredientFormViewModel.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 22/12/24.
//

import Foundation
import Combine

protocol IngredientFormViewModelProtocol: AnyObject {
    var viewState: IngredientFormViewModel.ViewState { get }
    var isEditing: Bool { get }
    var ingredientSubject: CurrentValueSubject<Ingredient?, Never> { get }
    
    func save() -> Bool
}

class IngredientFormViewModel: IngredientFormViewModelProtocol {
    
    class ViewState {
        @Published var isSaveButtonEnabled: Bool = false
        @Published var ingredientName: String = ""
    }
    
    private(set) var viewState = ViewState()
    
    private let ingredientDAO: IngredientDAOProtocol
    private(set) var ingredientSubject = CurrentValueSubject<Ingredient?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Outputs
    private(set) var isEditing: Bool = false
    
    // MARK: - Initialization
    init(ingredientDAO: IngredientDAOProtocol = IngredientDAO()) {
        self.ingredientDAO = ingredientDAO
        
        ingredientSubject
            .sink { [weak self] ingredient in
                guard let self = self else { return }
                
                self.isEditing = ingredient != nil
                
                if let existingIngredient = ingredient {
                    self.viewState.ingredientName = existingIngredient.name ?? ""
                }
            }
            .store(in: &cancellables)
        
        viewState.$ingredientName
            .map { !$0.isEmpty }
            .removeDuplicates()
            .assign(to: &viewState.$isSaveButtonEnabled)
    }
    
    // MARK: - Create or Update Ingredient
    func save() -> Bool {
        let ingredient = ingredientSubject.value ?? ingredientDAO.createInstance()
        ingredient.name = viewState.ingredientName
        
        return ingredientDAO.saveContext()
    }
}
