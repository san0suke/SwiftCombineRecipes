//
//  Array.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 27/12/24.
//

extension Array where Element: Equatable {
    mutating func remove(_ element: Element) {
        self.removeAll(where: { $0 == element })
    }
}
