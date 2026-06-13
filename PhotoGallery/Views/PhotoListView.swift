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
        if #available(iOS 16.0, *) {
            NavigationStack {
                List {
                    ForEach(vm.photos) { photo in
                        NavigationLink {
                            PhotoDetailView(photo: photo, viewModel: vm)
                        } label: {
                            PhotoRowView(photo: photo)
                        }
                        .onAppear {
                            guard vm.showDeleteAlertLoading else {
                                return
                            }
                            
                            guard let lastPhoto = vm.photos.last else {
                                return
                            }
                            
                            if photo.objectID == lastPhoto.objectID {
                                vm.loadNextPage()
                            }
                        }
                    }
                    .onDelete { indexSet in
                        guard let index = indexSet.first else { return }
                        selectedPhoto = vm.photos[index]
                        vm.showDeleteAlertLoading = true
                        showDeleteAlert = true
                    }
                }
                .alert("Delete Photo",
                       isPresented: $showDeleteAlert,
                       presenting: selectedPhoto) { photo in

                    Button("Delete", role: .destructive) {
                        vm.deletePhoto(photo)
                        vm.showDeleteAlertLoading = false
                    }

                    Button("Cancel", role: .cancel) {
                        vm.showDeleteAlertLoading = false
                    }

                } message: { _ in
                    Text("Are you sure you want to delete this photo?")
                }
                .overlay {
                    if vm.loading {
                        ProgressView()
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
                .navigationTitle("Photos")
            }
            .task {
                await vm.load()
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
