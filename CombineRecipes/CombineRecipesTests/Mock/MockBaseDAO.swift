//
//  MockBaseDAO.swift
//  CombineRecipes
//
//  Created by Robson Cesar de Siqueira on 19/12/24.
//

import CoreData
@testable import CombineRecipes

class MockBaseDAO: BaseDAOProtocol {
    
    var deleteCompletion: ((_ object: NSManagedObject) -> Bool)?
    var saveContextCompletion: (() -> Bool)?
    var fetchCompletion: (() -> [NSManagedObject])?
    
    func delete(_ object: NSManagedObject) -> Bool {
        return deleteCompletion?(object) ?? false
    }
    
    func saveContext() -> Bool {
        return saveContextCompletion?() ?? false
    }
    
    func fetch<T: NSManagedObject>() -> [T] {
        return fetchCompletion?() as? [T] ?? []
    }
}
