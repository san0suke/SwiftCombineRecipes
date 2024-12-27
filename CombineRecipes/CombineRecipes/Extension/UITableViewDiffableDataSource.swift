//
//  UITableViewDiffableDataSource.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 23/12/24.
//

import UIKit

extension UITableViewDiffableDataSource {
    func deleteItem(_ item: ItemIdentifierType, animatingDifferences: Bool = true) {
        var snapshot = self.snapshot()
        snapshot.deleteItems([item])
        self.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func refreshItem(_ item: ItemIdentifierType, animatingDifferences: Bool = true) {
        var snapshot = self.snapshot()
        snapshot.reloadItems([item])
        apply(snapshot, animatingDifferences: true)
    }
}

extension UITableViewDiffableDataSource where SectionIdentifierType == Int {
    func updateDataSource(with items: [ItemIdentifierType]) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        apply(snapshot, animatingDifferences: true)
    }
}
