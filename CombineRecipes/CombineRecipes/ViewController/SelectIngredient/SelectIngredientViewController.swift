//
//  SelectIngredientViewController.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 26/12/24.
//

import UIKit
import CoreData
import Combine

class SelectIngredientViewController: UIViewController {
    
    // MARK: - UI Components
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: - Properties
    private let completion: ([Ingredient]) -> Void
    private let viewModel: SelectIngredientViewModel
    private var dataSource: UITableViewDiffableDataSource<Int, Ingredient>?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(selectedIngredients: [Ingredient] = [],
         completion: @escaping ([Ingredient]) -> Void) {
        self.viewModel = SelectIngredientViewModel(selectedIngredients: selectedIngredients)
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Ingredients"
        view.backgroundColor = .white
        
        setupTableView()
        setupNavigationBar()
        setupDataSource()
        setupTableViewDelegate()
        setupBindings()
        viewModel.fetch()
    }
    
    // MARK: - Setup UI
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Ingredient>(tableView: tableView) { tableView, indexPath, ingredient in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = ingredient.name
            return cell
        }
    }

    private func setupTableViewDelegate() {
        tableView.delegate = self
    }
    
    private func setupBindings() {
        viewModel.ingredients
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ingredients in
                self?.updateDataSource(with: ingredients)
            }
            .store(in: &cancellables)
    }
    
    private func updateDataSource(with ingredients: [Ingredient]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Ingredient>()
        snapshot.appendSections([0])
        snapshot.appendItems(ingredients)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
//    private func bindTableView() {
//        Observable.combineLatest(viewModel.ingredients, viewModel.selectedIngredients)
//            .map { $0.0 }
//            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { [weak self] _, ingredient, cell in
//                guard let self = self else { return }
//                
//                cell.textLabel?.text = ingredient.name
//                
//                if self.viewModel.contains(ingredient) {
//                    cell.accessoryType = .checkmark
//                } else {
//                    cell.accessoryType = .none
//                }
//            }
//            .disposed(by: disposeBag)
//    }
    
    // MARK: - Actions
    @objc private func didTapDoneButton() {
        completion(Array(viewModel.selectedIngredients.value))
        
        dismiss(animated: true)
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
}

extension SelectIngredientViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let ingredient = dataSource?.itemIdentifier(for: indexPath),
            let cell = tableView.cellForRow(at: indexPath) else { return }

        if self.viewModel.contains(ingredient) {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        
        self.viewModel.onRowPressed(ingredient)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let ingredient = dataSource?.itemIdentifier(for: indexPath) else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            self?.viewModel.onRowPressed(ingredient)
            
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
