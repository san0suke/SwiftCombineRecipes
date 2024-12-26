//
//  IngredientFormViewController.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 22/12/24.
//

import UIKit
import Combine

class IngredientFormViewController: UIViewController {
    
    private let viewModel: IngredientFormViewModelProtocol
    private let completion: () -> Void
    private var cancellables = Set<AnyCancellable>()

    private(set) var nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Ingredient name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private(set) var saveButton: UIBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: nil, action: nil)
    private(set) var cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: nil, action: nil)
    
    var onDismiss: (() -> Void)?
    
    // MARK: - Initialization
    init(completion: @escaping () -> Void,
         ingredient: Ingredient? = nil,
         viewModel: IngredientFormViewModelProtocol = IngredientFormViewModel()) {
        self.completion = completion
        self.viewModel = viewModel
        self.viewModel.ingredientSubject.send(ingredient)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = viewModel.isEditing ? "Edit Ingredient" : "Add Ingredient"
        
        onDismiss = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.addSubview(nameTextField)
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
        
        nameTextField.addTarget(self, action: #selector(nameTextFieldDidChange(_:)), for: .editingChanged)
        
        saveButton.target = self
        saveButton.action = #selector(didTapSaveButton)
        
        cancelButton.target = self
        cancelButton.action = #selector(didTapCancelButton)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func bindViewModel() {
        viewModel.viewState.$ingredientName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                self?.nameTextField.text = name
            }
            .store(in: &cancellables)
        
        viewModel.viewState.$isSaveButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                self?.saveButton.isEnabled = enabled
            }
            .store(in: &cancellables)
    }
    
    @objc private func nameTextFieldDidChange(_ textField: UITextField) {
        viewModel.viewState.ingredientName = textField.text ?? ""
    }

    // MARK: - Actions
    @objc private func didTapSaveButton() {
        if viewModel.save() {
            completion()
            onDismiss?()
        }
    }

    @objc private func didTapCancelButton() {
        onDismiss?()
    }
}
