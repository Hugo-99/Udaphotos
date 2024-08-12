//
//  PhotoClient.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 22/07/2024.
//

import Foundation

class PhotoClient {
    static let shared = PhotoClient()
    private init() {}

    func searchPhotos(
        query: String,
        page: Int,
        perPage: Int = 20,
        orderBy: String = "relevant",
        collections: [String] = [],
        contentFilter: String = "low",
        color: String? = nil,
        orientation: String? = nil
    ) async throws -> [Photo] {
        let request = SearchPhotosRequest(
            query: query,
            page: page,
            perPage: perPage,
            orderBy: orderBy,
            collections: collections,
            contentFilter: contentFilter,
            color: color,
            orientation: orientation
        )

        let response: [String: Any] = try await NetworkManager.shared.request(request: request, method: .get)
        guard let results = response["results"] as? [[String: Any]] else {
            throw URLError(.cannotParseResponse)
        }

        let data = try JSONSerialization.data(withJSONObject: results)
        let photos = try JSONDecoder().decode([Photo].self, from: data)

        return photos
    }
}
