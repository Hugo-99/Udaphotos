//
//  SearchPhotosRequest.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 22/07/2024.
//

import Foundation

struct SearchPhotosRequest: NetworkRequest, Encodable {
    var query: String?
    var page: Int?
    var perPage: Int?
    var orderBy: String?
    var collections: [String]?
    var contentFilter: String?
    var color: String?
    var orientation: String?

    var api: String {
        return "search/photos"
    }

    enum CodingKeys: String, CodingKey {
        case query
        case page
        case perPage = "per_page"
        case orderBy = "order_by"
        case contentFilter = "content_filter"
        case color, collections, orientation
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(query, forKey: .query)
        try container.encodeIfPresent(page, forKey: .page)
        try container.encodeIfPresent(perPage, forKey: .perPage)
        try container.encodeIfPresent(orderBy, forKey: .orderBy)
        try container.encodeIfPresent(contentFilter, forKey: .contentFilter)
        try container.encodeIfPresent(color, forKey: .color)
        try container.encodeIfPresent(orientation, forKey: .orientation)
        try container.encodeIfPresent(collections, forKey: .collections)
    }

    init(query: String? = nil, page: Int? = nil, perPage: Int? = nil, orderBy: String? = nil, collections: [String]? = nil, contentFilter: String? = nil, color: String? = nil, orientation: String? = nil) {
        self.query = query
        self.page = page
        self.perPage = perPage
        self.orderBy = orderBy
        self.collections = collections
        self.contentFilter = contentFilter
        self.color = color
        self.orientation = orientation
    }

    func toJSON() -> [String: Any]? {
        var params = [String: Any]()
        if let query = query { params["query"] = query }
        if let page = page { params["page"] = page }
        if let perPage = perPage { params["per_page"] = perPage }
        if let orderBy = orderBy { params["order_by"] = orderBy }
        if let collections = collections { params["collections"] = collections.joined(separator: ",") }
        if let contentFilter = contentFilter { params["content_filter"] = contentFilter }
        if let color = color { params["color"] = color }
        if let orientation = orientation { params["orientation"] = orientation }
        return params
    }
}

