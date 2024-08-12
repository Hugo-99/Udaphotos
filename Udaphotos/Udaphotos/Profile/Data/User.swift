//
//  User.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 21/07/2024.
//

import Foundation

struct User: Codable {
    let id: String
    let updatedAt: String?
    let username: String?
    let firstName: String?
    let lastName: String?
    let twitterUsername: String?
    let portfolioUrl: String?
    let bio: String?
    let location: String?
    let totalLikes: Int?
    let totalPhotos: Int?
    let totalCollections: Int?
    let followedByUser: Bool?
    let downloads: Int?
    let uploadsRemaining: Int?
    let instagramUsername: String?
    let email: String?
    let links: [String: String]?

    init?(json: [String: Any]) {
        guard let id = json["id"] as? String,
              let updatedAt = json["updated_at"] as? String,
              let username = json["username"] as? String,
              let firstName = json["first_name"] as? String,
              let lastName = json["last_name"] as? String,
              let totalLikes = json["total_likes"] as? Int,
              let totalPhotos = json["total_photos"] as? Int,
              let totalCollections = json["total_collections"] as? Int,
              let followedByUser = json["followed_by_user"] as? Bool,
              let downloads = json["downloads"] as? Int,
              let uploadsRemaining = json["uploads_remaining"] as? Int,
              let email = json["email"] as? String,
              let links = json["links"] as? [String: String] else {
            return nil
        }

        self.id = id
        self.updatedAt = updatedAt
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.twitterUsername = json["twitter_username"] as? String
        self.portfolioUrl = json["portfolio_url"] as? String
        self.bio = json["bio"] as? String
        self.location = json["location"] as? String
        self.totalLikes = totalLikes
        self.totalPhotos = totalPhotos
        self.totalCollections = totalCollections
        self.followedByUser = followedByUser
        self.downloads = downloads
        self.uploadsRemaining = uploadsRemaining
        self.instagramUsername = json["instagram_username"] as? String
        self.email = email
        self.links = links
    }
}
