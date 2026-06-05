//
//  StocksRepository.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import Foundation

protocol StocksRepository: Sendable {
    func fetchStocks(page: Int) async throws -> [StockQuote]
    func fetchStockProfile(symbol: String) async throws -> StockProfile
}

extension StocksRepository {
    func fetchStocks() async throws -> [StockQuote] {
        try await fetchStocks(page: 1)
    }
}

enum StocksError: LocalizedError {
    case stockNotFound(String)

    var errorDescription: String? {
        switch self {
        case .stockNotFound(let symbol):
            return "Stock profile for \(symbol) was not found."
        }
    }
}
