//
//  PhotoListView.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 13/06/26.
//

import SwiftUI
import CoreData

struct PhotoListView: View {

    @StateObject private var vm = PhotoListViewModel()
    @State private var showDeleteAlert = false
    @State private var selectedPhoto: PhotoEntity?

    var body: some View {
        NavigationView {
            List {
                ForEach(vm.photos) { photo in
                    NavigationLink {
                        PhotoDetailView(photo: photo, viewModel: vm)
                    } label: {
                        PhotoRowView(photo: photo)
                    }
                    .onAppear {
                        // FIX: Delegate pagination to ViewModel to keep logic in one place
                        guard !showDeleteAlert else { return }
                        vm.shouldLoadNextPage(currentPhoto: photo)
                    }
                }
                .onDelete { indexSet in
                    // FIX: Bound-check to prevent crash if array changed
                    guard let index = indexSet.first,
                          index < vm.photos.count else { return }

                    selectedPhoto = vm.photos[index]
                    showDeleteAlert = true
                }
            }
            .navigationTitle("Photos")
            .navigationBarTitleDisplayMode(.large)
            .alert("Delete Photo", isPresented: $showDeleteAlert, presenting: selectedPhoto) { photo in
                Button("Delete", role: .destructive) {
                    vm.deletePhoto(photo)
                }
                Button("Cancel", role: .cancel) {}
            } message: { _ in
                Text("Are you sure you want to delete this photo?")
            }
            .overlay {
                if vm.loading {
                    ZStack {
                        Color.black.opacity(0.1)
                            .ignoresSafeArea()
                            .accessibilityHidden(true)                    // FIX: a11y

                        ProgressView("Loading...")
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                    }
                } else if vm.photos.isEmpty {
                    EmptyStateView()
                }
            }
            .overlay(alignment: .bottom) {
                if vm.showToast {
                    ToastView(
                        message: vm.toastMessage
                    )
                    .padding(.bottom, 30)
                    .transition(
                        .move(edge: .bottom)
                            .combined(with: .opacity)
                    )
                }
            }
        }
        .navigationViewStyle(.stack)
        .task {
            await vm.load()
        }
    }
}

#Preview {
    PhotoListView()
}
