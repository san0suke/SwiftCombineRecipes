//
//  IngredientFormViewControllerTests.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 24/12/24.
//

import XCTest
import CoreData
import Combine
@testable import CombineRecipes

class IngredientFormViewControllerTests: XCTestCase {
    
    var mockContext: NSManagedObjectContext!
    var mockViewModel: MockIngredientFormViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        cancellables = Set<AnyCancellable>()
        mockContext = MockNSPersistentContainer().viewContext
        mockViewModel = MockIngredientFormViewModel()
    }
    
    override func tearDown() {
        cancellables = nil
        mockViewModel = nil
        mockContext = nil
        super.tearDown()
    }
    
    func testViewControllerInitializationWithIngredient() {
        let ingredient = Ingredient(context: mockContext)
        var callbackCalled = false
        var ingredientSubjectCalled = false
        
        mockViewModel.isEditing = true
        
        mockViewModel.ingredientSubject
            .dropFirst()
            .sink { receivedIngredient in
            XCTAssertEqual(receivedIngredient, ingredient)
            
            ingredientSubjectCalled = true
        }
        .store(in: &cancellables)
        
        let viewController = createViewController(completion: {
            callbackCalled = true
        }, ingredient: ingredient)
        
        XCTAssertEqual(viewController.title, "Edit Ingredient")
        XCTAssertFalse(callbackCalled)
        XCTAssertTrue(ingredientSubjectCalled)
    }
    
    func testViewControllerInitializationWithoutIngredient() {
        var callbackCalled = false
        var ingredientSubjectCalled = false
        
        mockViewModel.ingredientSubject
            .dropFirst()
            .sink { _ in
            ingredientSubjectCalled = true
        }
        .store(in: &cancellables)
        
        let viewController = createViewController {
            callbackCalled = true
        }
        
        XCTAssertEqual(viewController.title, "Add Ingredient")
        XCTAssertFalse(callbackCalled)
        XCTAssertTrue(ingredientSubjectCalled)
    }
    
    func testChangeNameTextFieldShouldSetIngredientName() {
        let viewController = createViewController {}
        
        XCTAssertEqual(mockViewModel.viewState.ingredientName, "")
        
        viewController.nameTextField.text = "Bacon"
        viewController.nameTextField.sendActions(for: .editingChanged)
        
        XCTAssertEqual(mockViewModel.viewState.ingredientName, "Bacon")
    }
    
    func testIsSaveButtonEnabledShouldEnableSaveButton() {
        let enabledExpectation = expectation(description: "Save button enabled")
        
        mockViewModel.viewState.$isSaveButtonEnabled
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { isEnabled in
                enabledExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        let viewController = createViewController {}
        
        mockViewModel.viewState.isSaveButtonEnabled = true
        
        waitForExpectations(timeout: 3)
        
        XCTAssertTrue(viewController.saveButton.isEnabled)
    }
    
    func testIsSaveButtonDisabledShouldDisableSaveButton() {
        let enabledExpectation = expectation(description: "Save button enabled")
        
        mockViewModel.viewState.$isSaveButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { isEnabled in
                enabledExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        let viewController = createViewController {}
        
        waitForExpectations(timeout: 3)
        
        XCTAssertFalse(viewController.saveButton.isEnabled)
    }
    
    private func createViewController(completion: @escaping () -> Void, ingredient: Ingredient? = nil) -> IngredientFormViewController {
        let viewController = IngredientFormViewController(completion: completion, ingredient: ingredient, viewModel: mockViewModel)
        
        _ = viewController.view
        
        return viewController
    }
}
