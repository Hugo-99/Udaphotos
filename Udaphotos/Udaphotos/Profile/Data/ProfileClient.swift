//
//  ProfileClient.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 21/07/2024.
//

import Foundation

class ProfileClient {
    static let shared = ProfileClient()
    private init() {}

    public func getUserProfile() async throws -> User {
        let request = ProfileRequest()
        let json = try await NetworkManager.shared.request(request: request, method: .get)

        if let response = ProfileResponse(json: json), let user = response.user {
            return user
        } else {
            throw NSError(domain: "UserManagerErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse user profile"])
        }
    }

    public func updateUserProfile(request: UpdateProfileRequest) async throws -> User {
        let json = try await NetworkManager.shared.request(request: request, method: .put)

        if let response = ProfileResponse(json: json), let user = response.user {
            return user
        } else {
            throw NSError(domain: "UserManagerErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse updated user profile"])
        }
    }
}
