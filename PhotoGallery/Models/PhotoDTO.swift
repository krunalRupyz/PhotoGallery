//
//  PhotoDTO.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 13/06/26.
//

struct PhotoDTO: Codable, Identifiable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
