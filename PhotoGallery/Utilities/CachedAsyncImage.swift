//
//  CachedAsyncImage.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 13/06/26.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: String
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .task {
                        await loadImage()
                    }
            }
        }
    }
    
    func loadImage() async {
        if let cached =
            ImageCache.shared.object(forKey: NSString(string: url)) {
            image = cached
            return
        }
        
        guard let imageURL = URL(string: url)
        else { return }
        
        do {
            let (data, _) =
            try await URLSession.shared.data(
                from: imageURL
            )
            
            if let uiImage = UIImage(data: data) {
                ImageCache.shared.setObject(uiImage, forKey: NSString(string: url))
                image = uiImage
            }
            
        } catch {}
    }
}
