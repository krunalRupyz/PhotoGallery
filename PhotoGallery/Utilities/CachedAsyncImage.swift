//
//  CachedAsyncImage.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 13/06/26.
//

import SwiftUI
import Combine

/// Image view that caches loaded images in memory and on disk to avoid
/// re-downloading during scroll. iOS 15+ compatible.
struct CachedAsyncImage<Placeholder: View>: View {
    let url: String
    let placeholder: () -> Placeholder

    @StateObject private var loader: ImageLoader

    init(url: String,
         @ViewBuilder placeholder: @escaping () -> Placeholder = { ProgressView() }) {
        self.url = url
        self.placeholder = placeholder
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                placeholder()
            }
        }
        .onAppear { loader.load() }
        .onDisappear { loader.cancel() }
    }
}

// MARK: - Loader

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private let url: String
    private var task: URLSessionDataTask?

    // Shared caches
    private static let memoryCache = NSCache<NSString, UIImage>()
    private static let diskQueue = DispatchQueue(label: "image.disk.cache", qos: .utility)
    private static let diskDirectory: URL = {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageCache", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }()

    init(url: String) {
        self.url = url
    }

    func load() {
        // 1. Memory cache hit → instant
        if let cached = Self.memoryCache.object(forKey: url as NSString) {
            self.image = cached
            return
        }

        // 2. Disk cache hit → decode off-main, then publish
        let path = Self.diskDirectory.appendingPathComponent(Self.fileName(for: url))
        if let data = try? Data(contentsOf: path),
           let img = UIImage(data: data) {
            Self.memoryCache.setObject(img, forKey: url as NSString)
            self.image = img
            return
        }

        // 3. Network fetch
        guard let requestURL = URL(string: url) else { return }
        task = URLSession.shared.dataTask(with: requestURL) { [weak self] data, _, _ in
            guard let self, let data, let img = UIImage(data: data) else { return }
            Self.memoryCache.setObject(img, forKey: self.url as NSString)
            // Save to disk on a background queue
            Self.diskQueue.async {
                try? data.write(to: path, options: .atomic)
            }
            DispatchQueue.main.async { self.image = img }
        }
        task?.resume()
    }

    func cancel() {
        task?.cancel()
    }

    private static func fileName(for url: String) -> String {
        // Hash the URL to a safe filename
        return String(url.hashValue)
    }
}
