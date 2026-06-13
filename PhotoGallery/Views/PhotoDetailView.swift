//
//  PhotoDetailView.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 13/06/26.
//
import SwiftUI

struct PhotoDetailView: View {

    @ObservedObject var photo: PhotoEntity
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    private let repository = PhotoRepository()
    @ObservedObject var viewModel: PhotoListViewModel

    var body: some View {
        ScrollView {
            CachedAsyncImage(
                url: photo.url ?? ""
            )
            .frame(height: 300)
            GrowingTextEditor(text: $title)
            Button("Save") {
                viewModel.updatePhoto(
                    photoId: photo.id,
                    title: title
                )
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 20)
        }
        .padding()
        .onAppear {
            title = photo.title ?? ""
        }
    }
}
