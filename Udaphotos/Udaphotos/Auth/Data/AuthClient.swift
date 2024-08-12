//
//  AuthClient.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 07/07/2024.
//

import Foundation
import AuthenticationServices

final class AuthClient: NSObject {
    private let networkManager = AsyncAwaitNetworkManager()
    private let authDomain: String = "https://unsplash.com/oauth/"
    private var _credential: AuthCredential?

    public static let shared = AuthClient()

    var credential: AuthCredential? {
        get {
            return AuthCredential.localCredential()
        } set{
            _credential = newValue
            AuthCredential.storeCredential(for: _credential)
        }
    }

    enum Key: String {
        case secretKey = "YOUR_SECRET_KEY"
        case accessKey = "YOUR_ACCESS_KEY"
    }

    enum Attribute: String {
        case grandType = "authorization_code"
        case redirectUri = "udaphotos://unsplash"
        case responseType = "code"
        case scope = "public+read_user+write_user+read_photos+write_photos+write_likes+write_followers+read_collections+write_collections"
    }

    public func authorize() async throws -> String {
        let params = [
            URLQueryItem(name: "client_id", value: Key.accessKey.rawValue),
            URLQueryItem(name: "redirect_uri", value: Attribute.redirectUri.rawValue),
            URLQueryItem(name: "response_type", value: Attribute.responseType.rawValue),
            URLQueryItem(name: "scope", value: Attribute.scope.rawValue)
        ]

        var urlComponents = URLComponents(string: authDomain + "authorize")!
        urlComponents.queryItems = params

        guard let authURL = urlComponents.url else {
            throw NetworkManagerError.invalidURL
        }

        return try await withCheckedThrowingContinuation { continuation in
            let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: URLScheme.main) { callbackURL, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let callbackURL = callbackURL,
                      let code = callbackURL.value(of: "code") else {
                    continuation.resume(throwing: NetworkManagerError.invalidSession)
                    return
                }

                continuation.resume(returning: code)
            }

            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = true
            session.start()
        }
    }

    public func token(code: String) async throws -> String {
        let params = [
            "client_id": AuthClient.Key.accessKey.rawValue,
            "client_secret": AuthClient.Key.secretKey.rawValue,
            "redirect_uri": AuthClient.Attribute.redirectUri.rawValue,
            "code": code,
            "grant_type": AuthClient.Attribute.grandType.rawValue
        ]

        let url = authDomain + "token"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyString = params.map { "\($0.key)=\($0.value)" }
                                .joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)

        do {
            let result = try await networkManager.perform(request: request)
            let jsonObject = try JSONSerialization.jsonObject(with: result.data, options: []) as? [String: Any]

            guard let json = jsonObject else {
                 throw NSError(domain: "AuthErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"])
             }

             guard let accessToken = json["access_token"] as? String,
                   let tokenType = json["token_type"] as? String,
                   let scope = json["scope"] as? String,
                   let createdAt = json["created_at"] as? Double else {
                 throw NSError(domain: "AuthErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing token information"])
             }

            self.credential = AuthCredential(accessToken: accessToken, tokenType: tokenType, scope: scope, createdAt: createdAt)

            return accessToken
        } catch {
            throw NSError(domain: "AuthErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token request failed: \(error.localizedDescription)"])
        }
    }
}

extension AuthClient: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
