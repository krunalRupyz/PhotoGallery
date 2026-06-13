//
//  EmptyStateView.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 13/06/26.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text("No Photos Available")
                .font(.headline)

            Text("Photos will appear here once loaded.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}

#Preview {
    EmptyStateView()
}
