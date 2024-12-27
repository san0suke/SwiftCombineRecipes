//
//  RecipeFormViewController.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 26/12/24.
//

import UIKit
import CoreData
import Combine

class RecipeFormViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipe Name"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Recipe Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let selectIngredientsButton: UIButton = {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Ingredients"
        configuration.image = UIImage(systemName: "plus")
        configuration.imagePadding = 8
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        
        button.configuration = configuration
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let saveButton: UIBarButtonItem = {
        UIBarButtonItem(title: "Save", style: .done, target: nil, action: nil)
    }()
    
    private let completion: () -> Void
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: RecipeFormViewModelProtocol
    private var coordinator: RecipeFormCoordinatorProtocol
    private var dataSource: UITableViewDiffableDataSource<Int, Ingredient>?
    
    // MARK: - Initialization
    init(completion: @escaping () -> Void,
         recipe: Recipe? = nil,
         coordinator: RecipeFormCoordinatorProtocol = RecipeFormCoordinator()) {
        self.completion = completion
        self.viewModel = RecipeFormViewModel()
        self.viewModel.recipeSubject.send(recipe)
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = viewModel.isEditing ? "Edit Recipe" : "Add Recipe"
        
        setupUI()
        setupCoordinator()
        setupNavigationBar()
        setupTableView()
        setupDataSource()
        setupBindings()
        setupTableViewDelegate()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.addSubview(stackView)
        
        setupNameContainerView()
        stackView.addArrangedSubview(nameContainerView)
        stackView.addArrangedSubview(selectIngredientsButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        selectIngredientsButton.addTarget(self, action: #selector(onSelectIngredientTap), for: .touchUpInside)
    }

    private func setupCoordinator() {
        coordinator.navigationController = navigationController
    }
    
    private func setupNameContainerView() {
        nameContainerView.addSubview(subtitleLabel)
        nameContainerView.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: nameContainerView.topAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: nameContainerView.leadingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: nameContainerView.trailingAnchor, constant: -8),
            
            nameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: nameContainerView.leadingAnchor, constant: 8),
            nameTextField.trailingAnchor.constraint(equalTo: nameContainerView.trailingAnchor, constant: -8),
            nameTextField.bottomAnchor.constraint(equalTo: nameContainerView.bottomAnchor, constant: -8),
            nameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = saveButton
    }
    
    // MARK: - Actions
    
    @objc private func onSelectIngredientTap() {
        openSelectIngredient()
    }
    
    @objc private func didTapSaveButton() {
        if viewModel.save() {
            completion()
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func openSelectIngredient() {
        coordinator.presentSelectIngredient(with: viewModel.viewState.selectedIngredients) { [weak self] ingredients in
            self?.viewModel.updateSelectedIngredients(ingredients)
        }
    }
    
    // MARK: - Table
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Ingredient>(tableView: tableView) { tableView, indexPath, ingredient in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = ingredient.name
            return cell
        }
    }

    private func setupBindings() {
        viewModel.viewState.$selectedIngredients
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ingredients in
                self?.dataSource?.updateDataSource(with: ingredients)
            }
            .store(in: &cancellables)
    }

    private func setupTableViewDelegate() {
        tableView.delegate = self
    }
}

extension RecipeFormViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openSelectIngredient()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let ingredient = dataSource?.itemIdentifier(for: indexPath) else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            self?.viewModel.viewState.selectedIngredients.removeAll(where: { $0 == ingredient })
            self?.dataSource?.deleteItem(ingredient)
            
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
