//
//  UINavigationController.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import UIKit

extension UINavigationController: UINavigationControllerProtocol {
    
    func presentMediumModal(_ viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .pageSheet
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(navigationController, animated: true, completion: nil)
    }
}
