//
//  Photo.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 22/07/2024.
//

import Foundation
import UIKit

struct Photo: Codable {
    public let identifier: String
    public let height: Int
    public let width: Int
    public let user: User
    public let urls: Urls
    public let likesCount: Int
    public let downloadsCount: Int?
    public let viewsCount: Int?
    public let altDescription: String?
    public let description: String?
    public let createdAt: String?
    public let updatedAt: String?

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case height
        case width
        case user
        case urls
        case likesCount = "likes"
        case downloadsCount = "downloads"
        case viewsCount = "views"
        case altDescription = "alt_description"
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case sponsorship
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        height = try container.decode(Int.self, forKey: .height)
        width = try container.decode(Int.self, forKey: .width)
        user = try container.decode(User.self, forKey: .user)
        urls = try container.decode(Urls.self, forKey: .urls)
        likesCount = try container.decode(Int.self, forKey: .likesCount)
        downloadsCount = try? container.decode(Int.self, forKey: .downloadsCount)
        viewsCount = try? container.decode(Int.self, forKey: .viewsCount)
        altDescription = try? container.decode(String.self, forKey: .altDescription)
        description = try? container.decode(String.self, forKey: .description)
        createdAt = try? container.decode(String.self, forKey: .createdAt)
        updatedAt = try? container.decode(String.self, forKey: .updatedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(height, forKey: .height)
        try container.encode(width, forKey: .width)
        try container.encode(user, forKey: .user)
        try container.encode(urls, forKey: .urls)
        try container.encode(likesCount, forKey: .likesCount)
        try? container.encode(downloadsCount, forKey: .downloadsCount)
        try? container.encode(viewsCount, forKey: .viewsCount)
        try? container.encode(altDescription, forKey: .altDescription)
        try? container.encode(description, forKey: .description)
        try? container.encode(createdAt, forKey: .createdAt)
        try? container.encode(updatedAt, forKey: .updatedAt)
    }
}
