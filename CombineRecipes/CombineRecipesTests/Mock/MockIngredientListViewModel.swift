//
//  MockIngredientListViewModel.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 29/12/24.
//

import Foundation
import Combine
import CoreData
@testable import CombineRecipes

class MockIngredientListViewModel: IngredientListViewModelProtocol {
    
    // MARK: - Closures
    var fetchCompletion: (() -> Void)?
    var deleteCompletion: ((Ingredient) -> Void)?

    // MARK: - Protocol Properties
    var ingredients: CurrentValueSubject<[Ingredient], Never> = CurrentValueSubject([])

    // MARK: - Protocol Methods
    func fetch() {
        fetchCompletion?()
    }

    func delete(_ ingredient: Ingredient) {
        deleteCompletion?(ingredient)
    }
}

