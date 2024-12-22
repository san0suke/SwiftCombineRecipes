//
//  UINavigationControllerProtocol.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 21/12/24.
//

import UIKit

protocol UINavigationControllerProtocol: AnyObject {
    func presentMediumModal(_ viewController: UIViewController)
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}
