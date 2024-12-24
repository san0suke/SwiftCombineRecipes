//
//  MockIngredientFormViewModel.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 24/12/24.
//

import Foundation
import Combine
import CoreData
@testable import CombineRecipes

class MockIngredientFormViewModel: IngredientFormViewModelProtocol {
    
    // MARK: - Properties
    
    var viewState: IngredientFormViewModel.ViewState = IngredientFormViewModel.ViewState()
    var isEditing: Bool = false
    var ingredientSubject = CurrentValueSubject<Ingredient?, Never>(nil)
    
    // MARK: - Completions
    
    var saveCompletion: (() -> Bool)?
    var ingredientSubjectCompletion: ((Ingredient?) -> Void)?
    var ingredientNameChangeCompletion: ((String) -> Void)?
    
    // MARK: - Initialization
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Methods
    
    func save() -> Bool {
        return saveCompletion?() ?? false
    }
}
