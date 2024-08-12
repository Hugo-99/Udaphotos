//
//  AsyncAwaitNetworkManager.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 20/07/2024.
//

import Foundation

public class AsyncAwaitNetworkManager: AsyncAwaitNetworkManagerProtocol {
    private var accessToken: String?

    public init(accessToken: String? = nil) {
        self.accessToken = accessToken
    }

    public func perform(request: URLRequest) async throws -> RequestResult {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkManagerError.invalidSession
        }

        return (response: httpResponse, data: data)
    }

    public func perform(authRequest: URLRequest) async throws -> RequestResult {
        guard let accessToken = accessToken else {
            throw NetworkManagerError.missingSession
        }

        var request = authRequest
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkManagerError.invalidSession
        }

        if httpResponse.statusCode == 401 {
            // Handle 401 Unauthorized error, refresh token if necessary
            throw NetworkManagerError.invalidSession
        }

        return (response: httpResponse, data: data)
    }
}

