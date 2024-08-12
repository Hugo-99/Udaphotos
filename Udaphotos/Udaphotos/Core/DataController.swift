//
//  DataController.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 11/08/2024.
//

import Foundation
import CoreData

class DataController {
    static let shared = DataController(modelName: "Udaphotos")

    let persistentContainer: NSPersistentContainer
    private var isLoaded = false  // Flag to check if stores are loaded

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    let backgroundContext: NSManagedObjectContext!

    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        backgroundContext = persistentContainer.newBackgroundContext()
    }

    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true

        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }

    func load(completion: (() -> Void)? = nil) {
        guard !isLoaded else { // Check if already loaded
            completion?()
            return
        }

        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self.isLoaded = true // Mark stores as loaded
            self.configureContexts()
            completion?()
        }
    }
}
