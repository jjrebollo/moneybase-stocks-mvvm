//
//  NetworkError.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidResponse
    case unexpectedStatusCode(Int)
    case invalidURL
    case decodingFailed
    case missingAPIKey

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Received an invalid response from server."
        case .unexpectedStatusCode(let statusCode):
            return "Unexpected server status code: \(statusCode)."
        case .invalidURL:
            return "Unable to build a valid request URL."
        case .decodingFailed:
            return "Unable to parse server response."
        case .missingAPIKey:
            return "Missing RAPID_API_KEY. Configure it locally in your scheme or inject it from CI."
        }
    }
}
