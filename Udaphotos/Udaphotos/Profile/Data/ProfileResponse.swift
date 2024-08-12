//
//  ProfileResponse.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 21/07/2024.
//

import Foundation

struct ProfileResponse {
    let user: User?

    init?(json: [String: Any]) {
        self.user = User(json: json)
    }
}
