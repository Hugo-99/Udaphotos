//
//  URL+CodeValue.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 20/07/2024.
//

import Foundation

extension URL {
    func value(of queryParameter: String) -> String? {
        return URLComponents(string: self.absoluteString)?
            .queryItems?
            .first { $0.name == queryParameter }?
            .value
    }
}
