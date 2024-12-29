//
//  IngredientListViewControllerTests.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 29/12/24.
//

import XCTest
import CoreData
import Combine
@testable import CombineRecipes

class IngredientListViewControllerTests: XCTestCase {
    
    var mockContext: NSManagedObjectContext!
    var mockViewModel: MockIngredientListViewModel!
    var cancellables: Set<AnyCancellable>!
    var mockTableView: UITableView!
    var mockCoordinator: MockIngredientListCoordinator!
    
    override func setUp() {
        super.setUp()
        
        cancellables = Set<AnyCancellable>()
        mockContext = MockNSPersistentContainer().viewContext
        mockViewModel = MockIngredientListViewModel()
        mockTableView = UITableView()
        mockCoordinator = MockIngredientListCoordinator()
    }
    
    override func tearDown() {
        cancellables = nil
        mockViewModel = nil
        mockContext = nil
        super.tearDown()
    }
    
    func testTapOnAddShouldPresentForm() {
        let presentExpectation = expectation(description: "Should present form")
        let viewController = createViewController()
        
        mockCoordinator.presentIngredientFormCompletion = { ingredient, completion in
            presentExpectation.fulfill()
        }
        
        guard let addButton = viewController.navigationItem.rightBarButtonItem else {
            XCTFail("Navigation item should have an add button")
            return
        }
        
        _ = addButton.target?.perform(
            addButton.action,
            with: nil
        )
        
        waitForExpectations(timeout: 3)

        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
        XCTAssertNotNil(viewController.dataSource)
    }
    
    func testListTableShouldHave2Elements() {
        let updateExpectation = expectation(description: "Save button enabled")
        let expectedIngredients = [Ingredient(context: mockContext), Ingredient(context: mockContext)]
        
        mockViewModel.ingredients
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { ingredients in
                XCTAssertEqual(expectedIngredients, ingredients)
                updateExpectation.fulfill()
            }
            .store(in: &cancellables)
    
        _ = createViewController()
        
        mockViewModel.ingredients.send(expectedIngredients)
        
        waitForExpectations(timeout: 3)
        
        XCTAssertEqual(mockTableView.numberOfRows(inSection: 0), 2)
    }
    
    private func createViewController() -> IngredientListViewController {
        let viewController = IngredientListViewController(tableView: mockTableView,
                                                          viewModel: mockViewModel,
                                                          coordinator: mockCoordinator)
        
        _ = viewController.view
        
        return viewController
    }
}
