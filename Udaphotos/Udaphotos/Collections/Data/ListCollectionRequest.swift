//
//  ListCollectionRequest.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 22/07/2024.
//

import Foundation

struct ListCollectionsRequest: NetworkRequest {
    var page: Int?
    var perPage: Int?

    var api: String { return "collections" }

    enum CodingKeys: String, CodingKey {
        case page, perPage = "per_page"
    }

    func toJSON() -> [String: Any]? {
        var params = [String: Any]()
        if let page = page { params["page"] = page }
        if let perPage = perPage { params["per_page"] = perPage }
        return params
    }
}
