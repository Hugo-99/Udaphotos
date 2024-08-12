//
//  NetworkClient.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 21/07/2024.
//

import Foundation
import UIKit

class NetworkManager {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    // MARK: - Single Skeleton
    public static let shared = NetworkManager()

    private init() {}

    let domain: String = "https://api.unsplash.com/"

    // MARK: Headers
    private var headers: [String: String] {
        var tokenType: String = ""
        var accessToken: String = ""

        if let credential = AuthClient.shared.credential {
            tokenType = credential.tokenType
            accessToken = credential.accessToken
        } else {
            tokenType = "Client-ID"
            accessToken = ""
        }

        return [
            "Authorization": "\(tokenType) \(accessToken)"
        ]
    }

    // MARK: Request
    public func request(request: NetworkRequest, method: HTTPMethod) async throws -> [String: Any] {
        guard let endPoint = request.api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              var urlComponents = URLComponents(string: self.domain + endPoint) else {
            throw URLError(.badURL)
        }

        // GET queries parameters
        if method == .get, let parameters = try? request.toJSONData() {
            if let json = try? JSONSerialization.jsonObject(with: parameters, options: []) as? [String: Any] {
                var queryItems = [URLQueryItem]()
                for (key, value) in json {
                    queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                }
                urlComponents.queryItems = queryItems
            }
        }

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if method != .get, let parameters = try? request.toJSONData() {
            urlRequest.httpBody = parameters
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let errorStrings = json["errors"] as? [String] ?? ["Unknown error"]
                let error = NetworkError(errors: errorStrings)
                throw error
            } else {
                throw URLError(.badServerResponse)
            }
        }

        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return json
        } else if let array = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
            return ["results": array]
        } else {
            throw URLError(.cannotParseResponse)
        }
    }


    // MARK: Download photo
    func downloadPhoto(_ urlString: String?) async throws -> UIImage? {
        guard let url = URL(string: urlString ?? "") else { return nil }

        let (data, _) = try await URLSession.shared.data(from: url)

        return UIImage(data: data)
    }
}

extension Encodable {
    func toJSONData() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}
