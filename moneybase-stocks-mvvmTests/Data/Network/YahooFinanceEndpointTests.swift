//
//  YahooFinanceEndpointTests.swift
//  moneybase-stocks-mvvmTests
//
//  Created by Juan Jose Rebollo on 06/06/2026.
//

import Foundation
import Testing
@testable import moneybase_stocks_mvvm

struct YahooFinanceEndpointTests {
    private let configuration = RapidAPIConfiguration(
        apiKey: "secret",
        host: "yahoo-finance15.p.rapidapi.com",
        baseProtocol: "https",
        baseURL: "yahoo-finance15.p.rapidapi.com",
        port: nil
    )

    private func components(for request: URLRequest) throws -> URLComponents {
        let url = try #require(request.url)
        return try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
    }

    @Test("stocksList builds a GET request with scheme, host, path and query")
    func stocksListRequest() throws {
        let endpoint = YahooFinanceEndpoint.stocksList(
            configuration: configuration,
            page: 3,
            type: "STOCKS"
        )

        let request = try #require(endpoint.urlRequest)
        let components = try components(for: request)

        #expect(request.httpMethod == "GET")
        #expect(components.scheme == "https")
        #expect(components.host == "yahoo-finance15.p.rapidapi.com")
        #expect(components.path == "/api/v2/markets/tickers")

        let queryItems = Dictionary(
            uniqueKeysWithValues: (components.queryItems ?? []).map { ($0.name, $0.value) }
        )
        #expect(queryItems["page"] == "3")
        #expect(queryItems["type"] == "STOCKS")
    }

    @Test("stockProfile builds the profile path with ticker and module query")
    func stockProfileRequest() throws {
        let endpoint = YahooFinanceEndpoint.stockProfile(
            configuration: configuration,
            ticker: "AAPL",
            module: "asset-profile"
        )

        let request = try #require(endpoint.urlRequest)
        let components = try components(for: request)

        #expect(components.path == "/api/v1/markets/stock/modules")

        let queryItems = Dictionary(
            uniqueKeysWithValues: (components.queryItems ?? []).map { ($0.name, $0.value) }
        )
        #expect(queryItems["ticker"] == "AAPL")
        #expect(queryItems["module"] == "asset-profile")
    }

    @Test("request carries the configuration headers")
    func requestHeaders() throws {
        let endpoint = YahooFinanceEndpoint.stocksList(
            configuration: configuration,
            page: 1,
            type: "STOCKS"
        )

        let request = try #require(endpoint.urlRequest)

        #expect(request.value(forHTTPHeaderField: "x-rapidapi-host") == "yahoo-finance15.p.rapidapi.com")
        #expect(request.value(forHTTPHeaderField: "x-rapidapi-key") == "secret")
    }

    @Test("request omits the API key header when the key is missing")
    func requestWithoutApiKey() throws {
        let keylessConfiguration = RapidAPIConfiguration(
            apiKey: "",
            host: "yahoo-finance15.p.rapidapi.com",
            baseProtocol: "https",
            baseURL: "yahoo-finance15.p.rapidapi.com",
            port: nil
        )
        let endpoint = YahooFinanceEndpoint.stocksList(
            configuration: keylessConfiguration,
            page: 1,
            type: "STOCKS"
        )

        let request = try #require(endpoint.urlRequest)

        #expect(request.value(forHTTPHeaderField: "x-rapidapi-key") == nil)
    }
}
