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

    func load() async {
        loading = true
        try? await repository.loadData()
        allPhotos = repository.getPhotos()
        loadNextPage()
        loading = false
    }

    func refresh() {
        allPhotos = repository.getPhotos()
        currentPage = 0
        let start = 0
        let end = min(pageSize, allPhotos.count)
        photos = Array(allPhotos[start..<end])
        currentPage = 1
    }

    func loadNextPage() {
        guard !isLoadingNextPage else {
            return
        }

        let start = currentPage * pageSize
        let end = min(start + pageSize, allPhotos.count)

        guard start < end else {
            return
        }

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
        withAnimation {
            showToast = true
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2
        ) {
            withAnimation {
                self.showToast = false
            }
        }
    }

    func updatePhoto(photoId: Int64, title: String) {
        do {
            try repository.updateTitle(
                photoId: photoId,
                title: title
            )
            refresh()
            showToastMessage(
                "✅ Photo updated successfully"
            )
            
        } catch {
            showToastMessage(
                "❌ \(error.localizedDescription)"
            )
        }
    }

    func deletePhoto(_ photo: PhotoEntity) {
        do {
            try repository.deletePhoto(
                photoId: photo.id
            )
            refresh()
            showToastMessage(
                "🗑️ Photo deleted successfully"
            )
        } catch {
            showToastMessage(
                "❌ \(error.localizedDescription)"
            )
        }
    }
}
