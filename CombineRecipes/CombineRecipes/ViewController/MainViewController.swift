//
//  MainViewController.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 13/12/24.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recipes App"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var ingredientsButton: UIButton = {
        let button = UIButton()
        
        button.configuration = Self.createMainButtonConfig(
            title: "Ingredients",
            icon: "leaf"
        )
        return button
    }()
    
    private lazy var recipesButton: UIButton = {
        let button = UIButton()
        
        button.configuration = Self.createMainButtonConfig(
            title: "Recipes",
            icon: "book"
        )
        return button
    }()
    
    override func viewDidLoad() {
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(ingredientsButton)
        stackView.addArrangedSubview(recipesButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            ingredientsButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            ingredientsButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            recipesButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            recipesButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
        
        ingredientsButton.addTarget(self, action: #selector(onTapIngredients), for: .touchUpInside)
        recipesButton.addTarget(self, action: #selector(onTapRecipes), for: .touchUpInside)
    }
    
    @objc private func onTapIngredients() {
        navigationController?.pushViewController(IngredientListViewController(), animated: true)
    }
    
    @objc private func onTapRecipes() {
        navigationController?.pushViewController(RecipeListViewController(), animated: true)
    }
    
    private static func createMainButtonConfig(title: String, icon: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        configuration.image = UIImage(systemName: icon)
        configuration.imagePadding = 5
        
        return configuration
    }
}
