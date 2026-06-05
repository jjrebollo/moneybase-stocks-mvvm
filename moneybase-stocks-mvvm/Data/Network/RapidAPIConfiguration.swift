//
//  RapidAPIConfiguration.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Foundation

struct RapidAPIConfiguration: Sendable {
    let apiKey: String
    let host: String
    let baseProtocol: String
    let baseURL: String
    let port: Int?

    var hasAPIKey: Bool {
        !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var globalHeaders: [String: String] {
        var headers = [
            "x-rapidapi-host": host,
            "Content-Type": "application/json"
        ]

        if hasAPIKey {
            headers["x-rapidapi-key"] = apiKey
        }

        return headers
    }

    static let yahooFinance15 = RapidAPIConfiguration(
        apiKey: AppEnvironment.value(for: "RAPID_API_KEY") ?? "",
        host: "yahoo-finance15.p.rapidapi.com",
        baseProtocol: "https",
        baseURL: "yahoo-finance15.p.rapidapi.com",
        port: nil
    )
}

private enum AppEnvironment {
    static func value(for key: String) -> String? {
        if let envValue = ProcessInfo.processInfo.environment[key]?.trimmingCharacters(in: .whitespacesAndNewlines),
           !envValue.isEmpty {
            return envValue
        }

        if let infoValue = Bundle.main.object(forInfoDictionaryKey: key) as? String {
            let trimmed = infoValue.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty, trimmed != "$(\(key))" {
                return trimmed
            }
        }

        return nil
    }
}
