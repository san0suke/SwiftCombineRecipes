//
//  IngredientFormViewModelTests.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 24/12/24.
//

import XCTest
import CoreData
@testable import CombineRecipes

class IngredientFormViewModelTests: XCTestCase {
    
    var mockContext: NSManagedObjectContext!
    var viewModel: IngredientFormViewModel!
    var mockDAO: MockIngredientDAO!
    
    override func setUp() {
        super.setUp()
        
        mockContext = MockNSPersistentContainer().viewContext
        mockDAO = MockIngredientDAO()
        viewModel = IngredientFormViewModel(ingredientDAO: mockDAO)
    }
    
    override func tearDown() {
        viewModel = nil
        mockDAO = nil
        super.tearDown()
    }
    
    func testIngredientSubjectShouldSetVariables() {
        let ingredient = Ingredient(context: mockContext)
        ingredient.name = "Bacon"
        
        XCTAssertFalse(viewModel.viewState.isSaveButtonEnabled)
        XCTAssertEqual(viewModel.viewState.ingredientName, "")
        
        viewModel.ingredientSubject.send(ingredient)
        
        XCTAssertTrue(viewModel.viewState.isSaveButtonEnabled)
        XCTAssertEqual(viewModel.viewState.ingredientName, "Bacon")
    }
}
