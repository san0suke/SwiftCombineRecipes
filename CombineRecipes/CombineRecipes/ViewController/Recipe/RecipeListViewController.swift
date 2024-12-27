//
//  RecipeListViewController.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 26/12/24.
//

import UIKit
import Combine

class RecipeListViewController: UIViewController {

    private var coordinator: RecipeListCoordinatorProtocol
    private let tableView: UITableView
    private let viewModel: RecipeListViewModelProtocol

    private var dataSource: UITableViewDiffableDataSource<Int, Recipe>?
    private var cancellables = Set<AnyCancellable>()

    init(tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped),
         viewModel: RecipeListViewModelProtocol = RecipeListViewModel(),
         coordinator: RecipeListCoordinatorProtocol = RecipeListCoordinator()) {
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
        title = "Recipes"

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
        dataSource = UITableViewDiffableDataSource<Int, Recipe>(tableView: tableView) { tableView, indexPath, recipe in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = recipe.name
            return cell
        }
    }

    private func setupBindings() {
        viewModel.recipes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] recipes in
                self?.updateDataSource(with: recipes)
            }
            .store(in: &cancellables)
    }

    private func setupTableViewDelegate() {
        tableView.delegate = self
    }

    @objc private func addButtonTapped() {
        presentRecipeForm(for: nil)
    }

    private func updateDataSource(with recipes: [Recipe]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Recipe>()
        snapshot.appendSections([0])
        snapshot.appendItems(recipes)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func presentRecipeForm(for recipe: Recipe?) {
        coordinator.presentRecipeForm(for: recipe) { [weak self] in
            if let recipe = recipe {
                self?.dataSource?.refreshItem(recipe)
            }
            self?.viewModel.fetch()
        }
    }
}

extension RecipeListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let recipe = dataSource?.itemIdentifier(for: indexPath) else { return }
        presentRecipeForm(for: recipe)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let recipe = dataSource?.itemIdentifier(for: indexPath) else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            self?.viewModel.delete(recipe)
            self?.dataSource?.deleteItem(recipe)
            
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
