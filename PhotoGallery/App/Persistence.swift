//
//  CoreDataManager.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 13/06/26.
//

import CoreData

final class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "PhotoGallery")
        container.loadPersistentStores { _, error in

            if let error = error {
                fatalError("Core Data Error: \(error.localizedDescription)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
