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
    
    func save() -> Bool
}

class IngredientFormViewModel: IngredientFormViewModelProtocol {
    
    class ViewState {
        @Published var isSaveButtonEnabled: Bool = false
        @Published var ingredientName: String = ""
    }
    
    var viewState = ViewState()
    
//    private let ingredientDAO: RecipeIngredientDAOProtocol
//    private let disposeBag = DisposeBag()
//    
//    private(set) lazy var isSaveButtonEnabled: Observable<Bool> = {
//        return ingredientName
//            .map { !$0.isEmpty }
//            .distinctUntilChanged()
//    }()
//    

    // MARK: - Outputs
    private(set) var isEditing: Bool = false
//    
//    // MARK: - Initialization
//    init(ingredientDAO: RecipeIngredientDAOProtocol = RecipeIngredientDAO()) {
//        self.ingredientDAO = ingredientDAO
//        
//        ingredientRelay
//            .subscribe { [weak self] ingredient in
//                guard let self = self else { return }
//                
//                self.isEditing = ingredient != nil
//                
//                if let existingIngredient = ingredient {
//                    self.ingredientName.accept(existingIngredient.name ?? "")
//                }
//            }
//            .disposed(by: disposeBag)
//    }
//    
    // MARK: - Create or Update Ingredient
    func save() -> Bool {
//        let ingredientToReturn = ingredientRelay.value ?? ingredientDAO.createInstance()
//        ingredientToReturn.name = ingredientName.value
//        
//        return ingredientDAO.saveContext()
        return false
    }
}
