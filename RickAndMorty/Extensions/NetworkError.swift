//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Vladislav on 23.08.2024.
//

import UIKit

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "")
        case .invalidResponse:
            return NSLocalizedString("Unexpected status code", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "")
        }
    }
}
