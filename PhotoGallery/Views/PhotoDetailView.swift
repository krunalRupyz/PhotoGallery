//
//  PhotoDetailView.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 13/06/26.

import CoreData
import SwiftUI

struct PhotoDetailView: View {

    @ObservedObject var photo: PhotoEntity
    @ObservedObject var viewModel: PhotoListViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var showDeleteAlert = false
    @State private var initialTitle: String = ""        // FIX: track "no change" state

    var body: some View {
        ScrollView {
            detailImage                                  // FIX: extracted + safe URL handling
            GrowingTextEditor(text: $title)
            actionButtons
        }
        .padding()
        .navigationTitle("Photo Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // FIX: capture initial title once
            title = photo.title ?? ""
            initialTitle = photo.title ?? ""
        }
        .alert("Delete Photo", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deletePhoto(photo)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}            // FIX: explicit empty body
        } message: {
            Text("Are you sure you want to delete this photo?")
        }
    }
}

// MARK: - Subviews

private extension PhotoDetailView {

    /// Detail image with safe URL handling + placeholder.
    @ViewBuilder
    var detailImage: some View {
        if let urlString = photo.url, !urlString.isEmpty {
            CachedAsyncImage(url: urlString) {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .padding(40)
            }
            .frame(height: 300)
            .accessibilityLabel("Photo: \(photo.title ?? "untitled")")  // FIX: a11y
        } else {
            // FIX: fallback when URL is nil/empty
            ZStack {
                Color.gray.opacity(0.1)
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .padding(40)
            }
            .frame(height: 300)
            .accessibilityLabel("Photo unavailable")
        }
    }

    /// Save + Delete buttons.
    var actionButtons: some View {
        VStack(spacing: 16) {
            HStack {
                Button("Save") {
                    saveTitle()
                }
                .padding(.horizontal, 10)                                 // FIX: simpler API
                .buttonStyle(.borderedProminent)
                .disabled(!canSave)                                       // FIX: disable when invalid/unchanged

                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Text("Delete Photo")
                        .padding(.horizontal, 10)                         // FIX: simpler API
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(.top, 20)
    }
}

// MARK: - Validation

private extension PhotoDetailView {

    /// Title is non-empty and differs from the original.
    var canSave: Bool {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        return trimmed != initialTitle
    }

    /// Persist the trimmed title, dismiss on success.
    func saveTitle() {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.updatePhoto(photoId: photo.id, title: trimmed)
        dismiss()
    }
}

// MARK: - Preview

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let photo = PhotoEntity(context: context)
    photo.id = 1
    photo.title = "Sample Photo"
    photo.url = "https://via.placeholder.com/600"
    photo.thumbnailUrl = "https://via.placeholder.com/150"

    // FIX: no nested NavigationView
    return PhotoDetailView(photo: photo, viewModel: PhotoListViewModel())
}
