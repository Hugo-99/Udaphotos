//
//  AsyncAwaitNetworkManagerProtocol.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 20/07/2024.
//

import Foundation

public protocol AsyncAwaitNetworkManagerProtocol: AnyObject {
    func perform(request: URLRequest) async throws -> RequestResult
    func perform(authRequest: URLRequest) async throws -> RequestResult
}

public enum NetworkManagerError: Error {
    case missingSession
    case invalidSession
    case invalidURL
}

public typealias RequestResult = (response: HTTPURLResponse, data: Data)
