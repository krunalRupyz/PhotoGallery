//
//  PhotoGalleryApp.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 12/06/26.
//

import SwiftUI
import CoreData

@main
struct PhotoGalleryApp: App {

    let persistenceController =
    PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            PhotoListView()
                .environment(
                    \.managedObjectContext,
                     persistenceController.container.viewContext
                )
        }
    }
}
