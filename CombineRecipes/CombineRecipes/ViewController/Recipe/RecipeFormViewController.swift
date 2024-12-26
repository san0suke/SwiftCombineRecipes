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
    
    private let ingredientsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let saveButton: UIBarButtonItem = {
        UIBarButtonItem(title: "Save", style: .done, target: nil, action: nil)
    }()
    
    private let completion: () -> Void
    
    private let cancellables = Set<AnyCancellable>()
//    private let viewModel: RecipeFormViewModel
    
    // MARK: - Initialization
    init(completion: @escaping () -> Void, recipe: Recipe? = nil) {
        self.completion = completion
//        self.viewModel = RecipeFormViewModel(recipe: recipe)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Add Recipe"
        
        setupUI()
        setupNavigationBar()
        setupTableView()
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
        
        view.addSubview(ingredientsTableView)
        NSLayoutConstraint.activate([
            ingredientsTableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            ingredientsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ingredientsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ingredientsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
//        selectIngredientsButton.addTarget(self, action: #selector(onSelectIngredientTap), for: .touchUpInside)
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
        ingredientsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "IngredientCell")
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = saveButton
    }
    
//    private func bindViews() {
//        saveButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//                self?.didTapSaveButton()
//            })
//            .disposed(by: disposeBag)
//        
//        viewModel.recipeName
//            .bind(to: nameTextField.rx.text)
//            .disposed(by: disposeBag)
//        
//        nameTextField.rx.text.orEmpty
//            .bind(to: viewModel.recipeName)
//            .disposed(by: disposeBag)
//        
//        viewModel.selectedIngredientsRelay
//            .bind(to: ingredientsTableView.rx.items(cellIdentifier: "IngredientCell")) { _, ingredient, cell in
//                cell.textLabel?.text = ingredient.name ?? "Unnamed Ingredient"
//            }
//            .disposed(by: disposeBag)
//        
//        viewModel.isSaveButtonEnabled
//            .bind(to: saveButton.rx.isEnabled)
//            .disposed(by: disposeBag)
//        
//        ingredientsTableView.rx.modelDeleted(RecipeIngredient.self)
//            .subscribe { [weak self] ingredient in
//                self?.viewModel.delete(ingredient)
//            }
//            .disposed(by: disposeBag)
//        
//        ingredientsTableView.rx
//            .modelSelected(RecipeIngredient.self)
//            .subscribe { [weak self] _ in
//                self?.openSelectIngredientModal()
//            }
//            .disposed(by: disposeBag)
//
//    }
//    
//    // MARK: - Actions
//    
//    @objc private func onSelectIngredientTap() {
//        openSelectIngredientModal()
//    }
//    
//    @objc private func didTapSaveButton() {
//        if viewModel.save() {
//            completion()
//            navigationController?.popViewController(animated: true)
//        }
//    }
//    
//    private func openSelectIngredientModal() {
//        let viewController = SelectIngredientViewController(selectedIngredients: viewModel.selectedIngredientsRelay.value) { [weak self] ingredients in
//            guard let self = self else { return }
//            
//            viewModel.update(ingredients)
//        }
//        
//        navigationController?.presentMediumModal(viewController)
//    }
}
