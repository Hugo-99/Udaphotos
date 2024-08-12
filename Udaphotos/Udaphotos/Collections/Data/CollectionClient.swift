//
//  CollectionClient.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 22/07/2024.
//

import Foundation

class CollectionClient {
    static let shared = CollectionClient()
    private init() {}

    func listCollections(
        page: Int? = 1,
        perPage: Int? = 10
    ) async throws -> [Collection] {
        var request = ListCollectionsRequest()
        request.page = page
        request.perPage = perPage

        let json = try await NetworkManager.shared.request(request: request, method: .get)

        guard let results = json["results"] as? [[String: Any]] else {
            throw URLError(.cannotParseResponse)
        }

        let jsonData = try JSONSerialization.data(withJSONObject: results)
        let collections = try JSONDecoder().decode([Collection].self, from: jsonData)

        return collections
    }
}
