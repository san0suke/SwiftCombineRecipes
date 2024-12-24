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
        mockContext = nil
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
    
    func testSaveWithNewIngredientShouldCreateInstance() {
        var saveCalled = false
        var createInstanceCalled = false
        let ingredient = Ingredient(context: self.mockContext)
        
        mockDAO.saveContextCompletion = {
            saveCalled = true
            return true
        }
        mockDAO.createInstanceCompletion = {
            createInstanceCalled = true
            return ingredient
        }
        
        viewModel.viewState.ingredientName = "Bacon"
        
        XCTAssertTrue(viewModel.save())
        XCTAssertTrue(saveCalled)
        XCTAssertTrue(createInstanceCalled)
        XCTAssertEqual(ingredient.name, "Bacon")
    }
    
    func testSaveWithExistingIngredientShouldNotCreateInstance() {
        var saveCalled = false
        var createInstanceCalled = false
        let ingredient = Ingredient(context: self.mockContext)
        ingredient.name = "Bacon"
        
        mockDAO.saveContextCompletion = {
            saveCalled = true
            return true
        }
        mockDAO.createInstanceCompletion = {
            createInstanceCalled = true
            return Ingredient(context: self.mockContext)
        }
        
        viewModel.ingredientSubject.send(ingredient)
        viewModel.viewState.ingredientName = "Cheese"
        
        XCTAssertTrue(viewModel.save())
        XCTAssertTrue(saveCalled)
        XCTAssertFalse(createInstanceCalled)
        XCTAssertEqual(ingredient.name, "Cheese")
    }
}
