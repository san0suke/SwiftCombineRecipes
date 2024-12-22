//
//  CoreDataManager.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 14/12/24.
//

import CoreData

class CoreDataManager {

    // MARK: - Singleton
    static let shared = CoreDataManager()

    // MARK: - Persistent Container
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "CombineRecipes")

        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    // MARK: - Context
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
