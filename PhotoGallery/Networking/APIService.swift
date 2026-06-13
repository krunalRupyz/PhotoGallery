//
//  APIService.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 13/06/26.
//

import Foundation

final class APIService {

    static let shared = APIService()

    private init() {}

    func fetchPhotos() async throws -> [PhotoDTO] {

        let url = URL(string: "https://jsonplaceholder.typicode.com/photos")!

        let (data, _) = try await URLSession.shared.data(from: url)

        return try JSONDecoder().decode(
            [PhotoDTO].self,
            from: data
        )
    }
}
