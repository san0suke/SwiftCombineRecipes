//
//  SelectIngredientViewController.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 26/12/24.
//

import UIKit
import CoreData
//import RxSwift
//import RxCocoa

class SelectIngredientViewController: UIViewController {
    
    // MARK: - UI Components
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: - Properties
    private let completion: ([Ingredient]) -> Void
    private let viewModel: SelectIngredientViewModel
    
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
        
//        setupTableView()
//        setupNavigationBar()
//        bindTableView()
//        viewModel.fetch()
    }
//    
//    // MARK: - Setup UI
//    private func setupTableView() {
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "IngredientCell")
//        
//        view.addSubview(tableView)
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    private func setupNavigationBar() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))
//    }
//    
//    private func bindTableView() {
//        Observable.combineLatest(viewModel.ingredients, viewModel.selectedIngredients)
//            .map { $0.0 }
//            .bind(to: tableView.rx.items(cellIdentifier: "IngredientCell")) { [weak self] _, ingredient, cell in
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
//        
//        tableView.rx.modelSelected(Ingredient.self)
//            .subscribe { [weak self] ingredient in
//                self?.viewModel.onRowPressed(ingredient)
//            }
//            .disposed(by: disposeBag)
//    }
//    
//    // MARK: - Actions
//    @objc private func didTapDoneButton() {
//        completion(Array(viewModel.selectedIngredients.value))
//        
//        dismiss(animated: true)
//    }
//    
//    @objc private func didTapCancelButton() {
//        dismiss(animated: true)
//    }
}
