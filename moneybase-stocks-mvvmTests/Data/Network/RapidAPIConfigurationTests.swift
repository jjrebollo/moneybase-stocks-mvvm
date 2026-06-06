//
//  RapidAPIConfigurationTests.swift
//  moneybase-stocks-mvvmTests
//
//  Created by Juan Jose Rebollo on 06/06/2026.
//

import Testing
@testable import moneybase_stocks_mvvm

struct RapidAPIConfigurationTests {
    private func configuration(apiKey: String) -> RapidAPIConfiguration {
        RapidAPIConfiguration(
            apiKey: apiKey,
            host: "yahoo-finance15.p.rapidapi.com",
            baseProtocol: "https",
            baseURL: "yahoo-finance15.p.rapidapi.com",
            port: nil
        )
    }

    @Test("hasAPIKey is true for a non-empty key")
    func hasAPIKeyWithValue() {
        #expect(configuration(apiKey: "secret").hasAPIKey)
    }

    @Test("hasAPIKey is false for empty or whitespace keys", arguments: ["", "   ", "\n\t"])
    func hasAPIKeyWithoutValue(key: String) {
        #expect(configuration(apiKey: key).hasAPIKey == false)
    }

    @Test("globalHeaders include the host and content type")
    func globalHeadersBaseValues() {
        let headers = configuration(apiKey: "secret").globalHeaders

        #expect(headers["x-rapidapi-host"] == "yahoo-finance15.p.rapidapi.com")
        #expect(headers["Content-Type"] == "application/json")
    }

    @Test("globalHeaders include the API key only when present")
    func globalHeadersApiKey() {
        #expect(configuration(apiKey: "secret").globalHeaders["x-rapidapi-key"] == "secret")
        #expect(configuration(apiKey: "").globalHeaders["x-rapidapi-key"] == nil)
    }
}
