//
//  Collection.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 22/07/2024.
//

import Foundation

struct Collection: Decodable {
    struct CoverPhoto: Decodable {
        let urls: Urls
    }

    let id: String
    let title: String
    let details: String?
    let published_at: String
    let updated_at: String
    let total_photos: Int
    let cover_photo: CoverPhoto?

    private enum CodingKeys: String, CodingKey {
        case id, title
        case details = "description"
        case published_at, updated_at, total_photos, cover_photo
    }
}
