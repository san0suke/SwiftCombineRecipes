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
    
    // MARK: - Initialization
    init(completion: @escaping () -> Void,
         ingredient: Ingredient? = nil,
         viewModel: IngredientFormViewModelProtocol = IngredientFormViewModel()) {
        self.completion = completion
        self.viewModel = viewModel
        
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
        
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.addSubview(nameTextField)
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
        
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
        
        nameTextField.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                print(text)
                self?.viewModel.viewState.ingredientName = text
            }
            .store(in: &cancellables)
        
        // Bind save button tap
//        saveButton.tapPublisher
//            .sink { [weak self] in
//                self?.didTapSaveButton()
//            }
//            .store(in: &cancellables)
//        
//        // Bind cancel button tap
//        cancelButton.tapPublisher
//            .sink { [weak self] in
//                self?.didTapCancelButton()
//            }
//            .store(in: &cancellables)
        
        // Enable/disable save button
//        viewModel.isSaveButtonEnabled
//            .assign(to: \UIBarButtonItem.isEnabled, on: saveButton)
//            .store(in: &cancellables)
    }

    // MARK: - Actions
    private func didTapSaveButton() {
        if viewModel.save() {
            completion()
            dismiss(animated: true, completion: nil)
        }
    }

    private func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extensions for Combine Publishers
//extension UITextField {
//    var textPublisher: AnyPublisher<String?, Never> {
//        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
//            .compactMap { ($0.object as? UITextField)?.text }
//            .eraseToAnyPublisher()
//    }
//}
