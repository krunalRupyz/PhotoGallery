//
//  CoreDataManager.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 13/06/26.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    private var context: NSManagedObjectContext {
        // Assumes usage on the main thread. For background tasks, consider background contexts.
        return PersistenceController.shared.container.viewContext
    }
}

// MARK: - Helpers

enum CoreDataManagerError: LocalizedError {
    case photoNotFound
    var errorDescription: String? {
        switch self {
        case .photoNotFound:
            return "Photo not found."
        }
    }
}

// MARK: - Save

extension CoreDataManager {
    /// Saves an array of PhotoDTOs as PhotoEntity objects to Core Data.
    func savePhotos(_ photos: [PhotoDTO]) throws {
        let context = self.context
        let objects: [[String: Any]] = photos.map { photo in
            [
                "id": Int64(photo.id),
                "albumId": Int64(photo.albumId),
                "title": photo.title,
                "url": photo.url,
                "thumbnailUrl": photo.thumbnailUrl
            ]
        }

        let request = NSBatchInsertRequest(
            entityName: "PhotoEntity",
            objects: objects
        )

        request.resultType = .statusOnly
        try context.execute(request)
        context.refreshAllObjects()
    }

    // MARK: - Fetch

    /// Fetches all PhotoEntity objects sorted by id.
    func fetchPhotos() -> [PhotoEntity] {
        let request: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(key: "id", ascending: true)
        ]

        do {
            return try context.fetch(request)
        } catch {
            print("Fetch Error:", error)
            return []
        }
    }

    /// Fetches a PhotoEntity by its id.
    func fetchPhoto(by id: Int64) -> PhotoEntity? {
        let request: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %d", id)

        do {
            return try context.fetch(request).first
        } catch {
            print("Fetch Error:", error)
            return nil
        }
    }

    // MARK: - Update

    /// Updates the title of a PhotoEntity with the given photoId.
    func updateTitle(photoId: Int64, title: String) throws {
        guard let photo = fetchPhoto(by: photoId) else {
            throw CoreDataManagerError.photoNotFound
        }

        photo.title = title
        saveContext()
    }

    // MARK: - Delete

    /// Deletes a PhotoEntity with the given photoId.
    func deletePhoto(photoId: Int64) throws {
        guard let photo = fetchPhoto(by: photoId) else {
            throw CoreDataManagerError.photoNotFound
        }

        context.delete(photo)
        saveContext()
    }

    /// Deletes the specified PhotoEntity.
    func deletePhoto(_ photo: PhotoEntity) {
        context.delete(photo)
        saveContext()
    }

    /// Deletes all PhotoEntity objects.
    func deleteAllPhotos() {
        let request: NSFetchRequest<NSFetchRequestResult> = PhotoEntity.fetchRequest()

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(deleteRequest)
        } catch {
            print("Delete Error:", error)
        }
    }

    // MARK: - Save Context

    /// Saves changes in the context if needed.
    func saveContext() {
        guard context.hasChanges else {
            return
        }

        do {
            try context.save()
        } catch {
            print("Core Data Save Error:", error.localizedDescription)
        }
    }
}
