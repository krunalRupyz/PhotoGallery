//
//  CoreDataManager.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 13/06/26.
//

import Foundation

final class PhotoRepository {

    private let coreDataManager = CoreDataManager.shared

    func loadData() async throws {
        let localPhotos =
        coreDataManager.fetchPhotos()

        if localPhotos.isEmpty {
            let apiPhotos = try await APIService.shared.fetchPhotos()
            try coreDataManager.savePhotos(apiPhotos)
        }
    }

    func getPhotos() -> [PhotoEntity] {
        coreDataManager.fetchPhotos()
    }

    func updateTitle(photoId: Int64, title: String) throws {
        try coreDataManager.updateTitle(
            photoId: photoId,
            title: title
        )
    }

    func deletePhoto(photoId: Int64) throws {
        try coreDataManager.deletePhoto(photoId: photoId)
    }
}
