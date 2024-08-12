//
//  ProfileRequest.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 21/07/2024.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var api: String {
        return "me"
    }

    func toJSON() -> [String: Any]? {
        return nil
    }
}

struct UpdateProfileRequest: NetworkRequest {
    var username: String?
    var first_name: String?
    var last_name: String?
    var email: String?
    var url: String?
    var location: String?
    var bio: String?
    var instagram_username: String?

    var api: String {
        return "me"
    }

    func toJSON() -> [String : Any]? {
        return nil
    }
}
