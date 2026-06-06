//
//  RemoteStocksRepositoryTests.swift
//  moneybase-stocks-mvvmTests
//
//  Created by Juan Jose Rebollo on 06/06/2026.
//

import Foundation
import Testing
@testable import moneybase_stocks_mvvm

struct RemoteStocksRepositoryTests {
    private func configuration(apiKey: String = "secret") -> RapidAPIConfiguration {
        RapidAPIConfiguration(
            apiKey: apiKey,
            host: "yahoo-finance15.p.rapidapi.com",
            baseProtocol: "https",
            baseURL: "yahoo-finance15.p.rapidapi.com",
            port: nil
        )
    }

    private static let stocksListJSON = """
    {
        "body": [
            {
                "symbol": "AAPL",
                "name": "Apple Inc.",
                "lastsale": "$100.00",
                "netchange": "1.00",
                "pctchange": "1.00%",
                "marketCap": "2,000,000,000"
            }
        ]
    }
    """

    private static let profileJSON = """
    {
        "meta": { "symbol": "AAPL" },
        "body": {
            "website": "https://apple.com",
            "industry": "Consumer Electronics",
            "sector": "Technology",
            "longBusinessSummary": "Summary",
            "fullTimeEmployees": 161000
        }
    }
    """

    // MARK: - Success

    @Test("fetchStocks decodes the payload and maps it to domain models")
    func fetchStocksSuccess() async throws {
        let client = MockHTTPClient(json: Self.stocksListJSON)
        let sut = RemoteStocksRepository(httpClient: client, configuration: configuration())

        let quotes = try await sut.fetchStocks(page: 1)

        #expect(quotes.map(\.symbol) == ["AAPL"])
        #expect(quotes.first?.name == "Apple Inc.")
    }

    @Test("fetchStocks sends a request for the requested page with the API key")
    func fetchStocksBuildsRequest() async throws {
        let client = MockHTTPClient(json: Self.stocksListJSON)
        let sut = RemoteStocksRepository(httpClient: client, configuration: configuration())

        _ = try await sut.fetchStocks(page: 7)

        let request = try #require(client.sentRequests.first)
        let url = try #require(request.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect(components.path == "/api/v2/markets/tickers")
        #expect(components.queryItems?.contains(URLQueryItem(name: "page", value: "7")) == true)
        #expect(request.value(forHTTPHeaderField: "x-rapidapi-key") == "secret")
    }

    @Test("fetchStockProfile decodes and maps the profile")
    func fetchStockProfileSuccess() async throws {
        let client = MockHTTPClient(json: Self.profileJSON)
        let sut = RemoteStocksRepository(httpClient: client, configuration: configuration())

        let profile = try await sut.fetchStockProfile(symbol: "AAPL")

        #expect(profile.symbol == "AAPL")
        #expect(profile.industry == "Consumer Electronics")
        #expect(profile.fullTimeEmployees == 161000)
    }

    // MARK: - Failure

    @Test("missing API key fails fast without hitting the client")
    func missingAPIKey() async {
        let client = MockHTTPClient(json: Self.stocksListJSON)
        let sut = RemoteStocksRepository(httpClient: client, configuration: configuration(apiKey: ""))

        await #expect {
            _ = try await sut.fetchStocks(page: 1)
        } throws: { error in
            isNetworkError(error, .missingAPIKey)
        }

        #expect(client.sentRequests.isEmpty)
    }

    @Test("non-success status codes throw unexpectedStatusCode")
    func unexpectedStatusCode() async {
        let client = MockHTTPClient(json: Self.stocksListJSON, statusCode: 500)
        let sut = RemoteStocksRepository(httpClient: client, configuration: configuration())

        await #expect {
            _ = try await sut.fetchStocks(page: 1)
        } throws: { error in
            isNetworkError(error, .unexpectedStatusCode(500))
        }
    }

    @Test("invalid payloads throw decodingFailed")
    func decodingFailure() async {
        let client = MockHTTPClient(json: #"{ "unexpected": true }"#)
        let sut = RemoteStocksRepository(httpClient: client, configuration: configuration())

        await #expect {
            _ = try await sut.fetchStockProfile(symbol: "AAPL")
        } throws: { error in
            isNetworkError(error, .decodingFailed)
        }
    }

    @Test("transport errors propagate")
    func transportErrorPropagates() async {
        struct TransportError: Error {}
        let client = MockHTTPClient(stub: .failure(TransportError()))
        let sut = RemoteStocksRepository(httpClient: client, configuration: configuration())

        await #expect(throws: TransportError.self) {
            _ = try await sut.fetchStocks(page: 1)
        }
    }

    private func isNetworkError(_ error: any Error, _ expected: NetworkError) -> Bool {
        guard let error = error as? NetworkError else { return false }
        switch (error, expected) {
        case (.missingAPIKey, .missingAPIKey),
            (.invalidURL, .invalidURL),
            (.invalidResponse, .invalidResponse),
            (.decodingFailed, .decodingFailed):
            return true
        case let (.unexpectedStatusCode(lhs), .unexpectedStatusCode(rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}
