//
//  ImageCache.swift
//  PhotoGallery
//
//  Created by Krunal chaudhari on 13/06/26.
//
import Foundation
import UIKit

final class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}
