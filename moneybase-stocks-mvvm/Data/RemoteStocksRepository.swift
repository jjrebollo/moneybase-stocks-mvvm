//
//  RemoteStocksRepository.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Foundation

actor RemoteStocksRepository: StocksRepository {
    private let httpClient: any HTTPClient
    private let configuration: RapidAPIConfiguration
    private let decoder: JSONDecoder

    init(
        httpClient: any HTTPClient,
        configuration: RapidAPIConfiguration,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.httpClient = httpClient
        self.configuration = configuration
        self.decoder = decoder
    }

    func fetchStocks() async throws -> [StockQuote] {
        let payload: StocksListResponseDTO = try await performRequest(
            from: YahooFinanceEndpoint.stocksList(configuration: configuration, page: 1, type: "STOCKS")
        )
        AppLogger.debug("fetchStocks response received", category: "Network")
        AppLogger.debug("payload: \(payload)", category: "Network")
        
        return await payload.parseToDomainModel()
    }

    func fetchStockProfile(symbol: String) async throws -> StockProfile {
        let payload: StockProfileResponseDTO = try await performRequest(
            from: YahooFinanceEndpoint.stockProfile(configuration: configuration, ticker: symbol, module: "asset-profile")
        )
        AppLogger.debug("fetchStockProfile response received", category: "Network")
        AppLogger.debug("payload: \(payload)", category: "Network")
        
        return await payload.parseToDomainModel()
    }

    private func performRequest<T: Decodable>(from endpoint: some ApiBuilder) async throws -> T {
        let (data, _) = try await performRequest(from: endpoint)

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }

    private func performRequest(from endpoint: some ApiBuilder) async throws -> (Data, HTTPURLResponse) {
        guard await configuration.hasAPIKey else {
            throw NetworkError.missingAPIKey
        }

        guard let request = await endpoint.urlRequest else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await httpClient.send(request)
        try await Self.validate(response: response)
        return (data, response)
    }

    private static func validate(response: HTTPURLResponse) throws {
        guard (200...299).contains(response.statusCode) else {
            throw NetworkError.unexpectedStatusCode(response.statusCode)
        }
    }
}
