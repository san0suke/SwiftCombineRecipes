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

    private var dataSource: UITableViewDiffableDataSource<Int, Ingredient>!

    private var addButtonTappedSubject = PassthroughSubject<Void, Never>()
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

        setupCoordinator()
        setupUI()
        setupDataSource()
        setupBindings()
        viewModel.fetch()
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
        
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(addButtonTapped)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Ingredient>(tableView: tableView) { tableView, indexPath, ingredient in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = ingredient.name
            return cell
        }
    }

    private func setupBindings() {
        // Bind ingredients to tableView using diffable data source
        viewModel.ingredients
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ingredients in
                self?.updateDataSource(with: ingredients)
            }
            .store(in: &cancellables)

        // Bind tableView item deletions to modelDeletedSubject
//        tableView.didDeleteRowAtPublisher()
//            .compactMap { [weak self] indexPath -> Ingredient? in
//                guard let self = self else { return nil }
//                let dataSource = self.viewModel.ingredients.value
//                return dataSource[indexPath.row]
//            }
//            .sink { [weak self] ingredient in
//                self?.modelDeletedSubject.send(ingredient)
//            }
//            .store(in: &cancellables)

        // Handle modelDeletedSubject
        modelDeletedSubject
            .sink { [weak self] ingredient in
                self?.viewModel.delete(ingredient)
            }
            .store(in: &cancellables)

        // Bind tableView item selections to modelSelectedSubject
//        tableView.didSelectRowAtPublisher()
//            .compactMap { [weak self] indexPath -> Ingredient? in
//                guard let self = self else { return nil }
//                let dataSource = self.viewModel.ingredients.value
//                return dataSource[indexPath.row]
//            }
//            .sink { [weak self] ingredient in
//                self?.modelSelectedSubject.send(ingredient)
//            }
//            .store(in: &cancellables)

        // Handle modelSelectedSubject
        modelSelectedSubject
            .sink { [weak self] ingredient in
                self?.presentIngredientForm(for: ingredient)
            }
            .store(in: &cancellables)
    }
    
    @objc private func addButtonTapped() {
        presentIngredientForm(for: nil)
    }

    private func updateDataSource(with ingredients: [Ingredient]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Ingredient>()
        snapshot.appendSections([0])
        snapshot.appendItems(ingredients)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func presentIngredientForm(for ingredient: Ingredient?) {
        coordinator.presentIngredientForm(for: ingredient) { [weak self] in
            self?.viewModel.fetch()
        }
    }
}
