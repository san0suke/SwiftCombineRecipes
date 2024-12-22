//
//  MockNavigationController.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 20/12/24.
//

import UIKit
@testable import CombineRecipes

class MockNavigationController: UINavigationControllerProtocol {
    
    var pushViewControllerCompletion: ((_ viewController: UIViewController, _ animated: Bool) -> Void)?
    var presentViewControllerCompletion: ((_ viewControllerToPresent: UIViewController, _ animated: Bool, _ completion: (() -> Void)?) -> Void)?
    var dismissCompletion: ((_ animated: Bool, _ completion: (() -> Void)?) -> Void)?
    var presentMediumModalCompletion: ((_ viewController: UIViewController) -> Void)?
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerCompletion?(viewController, animated)
    }
    
    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presentViewControllerCompletion?(viewControllerToPresent, animated, completion)
    }
    
    func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        dismissCompletion?(flag, completion)
    }
    
    func presentMediumModal(_ viewController: UIViewController) {
        presentMediumModalCompletion?(viewController)
    }
}
