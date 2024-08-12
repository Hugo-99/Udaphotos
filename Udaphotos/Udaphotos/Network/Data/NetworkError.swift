//
//  NetworkError.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 21/07/2024.
//

import Foundation

class NetworkError: LocalizedError {
    let errors: [String]

    init(errors: [String]) {
        self.errors = errors
    }

    var errorDescription: String? {
        get {
            return self.errors.joined(separator: "\n")
        }
    }
}
