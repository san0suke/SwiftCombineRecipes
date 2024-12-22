//
//  BaseDAO.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 16/12/24.
//

import CoreData

protocol BaseDAOProtocol {
    func delete(_ object: NSManagedObject) -> Bool
    func saveContext() -> Bool
}

class BaseDAO: BaseDAOProtocol {
    
    // MARK: - Properties
    let context: NSManagedObjectContext

    // MARK: - Initialization
    init(context: NSManagedObjectContext = CoreDataManager.shared.persistentContainer.viewContext) {
        self.context = context
    }
    
    // MARK: - Delete
    func delete(_ object: NSManagedObject) -> Bool {
        context.delete(object)
        return saveContext()
    }
    
    func saveContext() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            print("Failed to update Ingredient: \(error)")
            return false
        }
    }
}
