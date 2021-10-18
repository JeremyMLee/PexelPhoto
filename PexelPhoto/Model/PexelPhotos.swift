//
//  PexelPhotos.swift
//  PexelPhoto
//
//  Created by Jeremy Lee on 10/17/21.
//

import Foundation
import UIKit

// MARK: - PexelPhotos

struct PexelPhotos: Codable {
    var page, perPage: Int!
    var photos: [Photo]!
    var totalResults: Int!
    var nextPage: String!
}

// MARK: - Photo

struct Photo: Codable {
    var id, width, height: Int?
    var url: String?
    var photographer: String?
    var photographerURL: String?
    var photographerID: Int?
    var avgColor: String?
    var src: Src?
    var liked: Bool?
}

// MARK: - Src

struct Src: Codable {
    var original, large2X, large, medium: String?
    var small, portrait, landscape, tiny: String?
}

// MARK: - ImageArray Holder

struct PexelImages {
    var image: UIImage!
    var portrait: String!
    var landscape: String!
    var owner: String!
}
