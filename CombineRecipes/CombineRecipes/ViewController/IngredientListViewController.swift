//
//  IngredientListViewController.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 22/12/24.
//

import UIKit
import Combine

class IngredientListViewController: UIViewController {

    private var coordinator: IngredientListCoordinatorProtocol
    private let tableView: UITableView
    private let viewModel: IngredientsListViewModelProtocol
    
    // Combine subjects to handle user interactions
    private var modelDeletedSubject = PassthroughSubject<Ingredient, Never>()
    private var modelSelectedSubject = PassthroughSubject<Ingredient, Never>()

    private var cancellables = Set<AnyCancellable>()

    init(tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped),
         viewModel: IngredientsListViewModelProtocol = IngredientsListViewModel(),
         coordinator: IngredientListCoordinatorProtocol = IngredientListCoordinator()) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCoordinator() // Link the coordinator to the navigation controller
        setupUI()          // Configure the UI elements
        setupBindings()    // Bind data and user interactions to Combine publishers
        viewModel.fetch()  // Trigger initial data fetch
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Ingredients"

        setupNavigationBar()
        setupTableView()
    }

    private func setupCoordinator() {
        coordinator.navigationController = navigationController
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupBindings() {
        navigationItem.rightBarButtonItem?
            .publisher
            .sink(receiveValue: { [weak self] _ in
                self?.presentIngredientForm(for: nil)
            })
            .store(in: &cancellables)
        
        viewModel.ingredients
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ingredients in
                self?.updateTableView(with: ingredients)
            }
            .store(in: &cancellables)

//        tableView.publisher(for: \.didDeleteRowAt)
//            .compactMap { [weak self] indexPath -> Ingredient? in
//                guard let self = self,
//                      let dataSource = self.viewModel.ingredients.value as? [Ingredient] else { return nil }
//                return dataSource[indexPath.row]
//            }
//            .sink { [weak self] ingredient in
//                self?.modelDeletedSubject.send(ingredient)
//            }
//            .store(in: &cancellables)
//
//        // Handle modelDeletedSubject to delete an ingredient
//        modelDeletedSubject
//            .sink { [weak self] ingredient in
//                self?.viewModel.delete(ingredient)
//            }
//            .store(in: &cancellables)
//
//        // Bind table view row selections to modelSelectedSubject
//        tableView.publisher(for: \\.didSelectRowAt)
//            .compactMap { [weak self] indexPath -> Ingredient? in
//                guard let self = self,
//                      let dataSource = self.viewModel.ingredients.value as? [Ingredient] else { return nil }
//                return dataSource[indexPath.row]
//            }
//            .sink { [weak self] ingredient in
//                self?.modelSelectedSubject.send(ingredient)
//            }
//            .store(in: &cancellables)
//
//        // Handle modelSelectedSubject to present the ingredient form
//        modelSelectedSubject
//            .sink { [weak self] ingredient in
//                self?.presentIngredientForm(for: ingredient)
//            }
//            .store(in: &cancellables)
    }

    private func updateTableView(with ingredients: [Ingredient]) {
        tableView.reloadData()
    }

    private func presentIngredientForm(for ingredient: Ingredient?) {
        coordinator.presentIngredientForm(for: ingredient) { [weak self] in
            self?.viewModel.fetch()
        }
    }
}
