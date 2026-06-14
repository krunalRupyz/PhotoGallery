//
//  PhotoListViewModel.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 13/06/26.
//
import Foundation
import Combine
import SwiftUI
import CoreData

@MainActor
final class PhotoListViewModel: ObservableObject {
    @Published var photos: [PhotoEntity] = []
    @Published var loading = false
    private var allPhotos: [PhotoEntity] = []
    private let repository = PhotoRepository()

    private var currentPage = 0
    let pageSize = 50

    // Toast properties
    @Published var toastMessage: String = ""
    @Published var showToast = false
    
    @Published var isLoadingNextPage = false
    @Published var showDeleteAlertLoading = false
    @Published var errorMessage: String?

    func load() async {
        loading = true
        errorMessage = nil
        defer { loading = false }
        
        do {
            try await repository.loadData()
            allPhotos = repository.getPhotos()
            currentPage = 0
            photos = []
            loadNextPage()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refresh() {
        allPhotos = repository.getPhotos()
        currentPage = 0
        photos = []
        loadNextPage() // will load page 0
    }


    func loadNextPage() {
        guard !isLoadingNextPage else { return }

        let start = currentPage * pageSize
        let end = min(start + pageSize, allPhotos.count)
        guard start < allPhotos.count else { return } // also guard on `start` not `start < end` to handle end == start cleanly

        isLoadingNextPage = true
        photos.append(contentsOf: allPhotos[start..<end])
        currentPage += 1
        isLoadingNextPage = false
    }


    func shouldLoadNextPage(currentPhoto: PhotoEntity) {
        guard !showDeleteAlertLoading else {
            return
        }

        guard let lastPhoto = photos.last else {
            return
        }

        guard currentPhoto.objectID == lastPhoto.objectID else {
            return
        }

        loadNextPage()
    }

    private func showToastMessage(_ message: String) {
        toastMessage = message
        withAnimation { showToast = true }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { self.showToast = false }
        }
    }

    func updatePhoto(photoId: Int64, title: String) {
        do {
            try repository.updateTitle(photoId: photoId, title: title)
            if let index = photos.firstIndex(where: { $0.id == photoId }) {
                photos[index].title = title
            }
            showToastMessage("✅ Photo updated successfully")
        } catch {
            showToastMessage("❌ \(error.localizedDescription)")
        }
    }

    func deletePhoto(_ photo: PhotoEntity) {
        do {
            try repository.deletePhoto(photoId: photo.id)
            photos.removeAll { $0.objectID == photo.objectID }
            allPhotos.removeAll { $0.objectID == photo.objectID }
            showToastMessage("🗑️ Photo deleted successfully")
        } catch {
            showToastMessage("❌ \(error.localizedDescription)")
        }
    }
}
