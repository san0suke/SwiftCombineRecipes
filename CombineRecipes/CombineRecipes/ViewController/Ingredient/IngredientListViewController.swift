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
    private let viewModel: IngredientListViewModelProtocol

    private var dataSource: UITableViewDiffableDataSource<Int, Ingredient>?
    private var cancellables = Set<AnyCancellable>()

    init(tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped),
         viewModel: IngredientListViewModelProtocol = IngredientListViewModel(),
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
        setupTableViewDelegate()
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
        viewModel.ingredients
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ingredients in
                self?.dataSource?.updateDataSource(with: ingredients)
            }
            .store(in: &cancellables)
    }

    private func setupTableViewDelegate() {
        tableView.delegate = self
    }

    @objc private func addButtonTapped() {
        presentIngredientForm(for: nil)
    }

    private func presentIngredientForm(for ingredient: Ingredient?) {
        coordinator.presentIngredientForm(for: ingredient) { [weak self] in
            if let ingredient = ingredient {
                self?.dataSource?.refreshItem(ingredient)
            }
            self?.viewModel.fetch()
        }
    }
}

extension IngredientListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let ingredient = dataSource?.itemIdentifier(for: indexPath) else { return }
        presentIngredientForm(for: ingredient)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let ingredient = dataSource?.itemIdentifier(for: indexPath) else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            self?.viewModel.delete(ingredient)
            self?.dataSource?.deleteItem(ingredient)
            
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
