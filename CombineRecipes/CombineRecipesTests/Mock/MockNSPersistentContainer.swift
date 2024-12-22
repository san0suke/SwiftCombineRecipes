//
//  MockNSPersistentContainer.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 21/12/24.
//

import CoreData

class MockNSPersistentContainer {
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init() {
        persistentContainer = NSPersistentContainer(name: "CombineRecipes")
        
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load in-memory persistent store: \(error.localizedDescription)")
            }
        }
    }
    
    func createBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}
