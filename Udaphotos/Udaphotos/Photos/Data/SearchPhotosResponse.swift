//
//  SearchPhotosResponse.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 22/07/2024.
//

import Foundation

struct SearchPhotosResponse: Decodable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
}
