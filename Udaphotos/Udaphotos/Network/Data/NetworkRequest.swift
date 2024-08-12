//
//  NetworkRequest.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 21/07/2024.
//

import Foundation

protocol NetworkRequest: Encodable {
    var api: String { get }
    func toJSON() -> [String: Any]?
}

