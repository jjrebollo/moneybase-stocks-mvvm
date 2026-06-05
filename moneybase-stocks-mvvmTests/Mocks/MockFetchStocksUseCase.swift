//
//  MockFetchStocksUseCase.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Foundation
@testable import moneybase_stocks_mvvm

nonisolated final class MockFetchStocksUseCase: @unchecked Sendable, FetchStocksUseCaseProtocol {
    var stocksByPage: [Int: [StockQuote]]
    var error: Error?

    private(set) var requestedPages: [Int] = []

    init(stocksByPage: [Int: [StockQuote]] = [:], error: Error? = nil) {
        self.stocksByPage = stocksByPage
        self.error = error
    }

    func handle(input: Int?) async throws -> [StockQuote] {
        let page = input ?? 1
        requestedPages.append(page)

        if let error {
            throw error
        }

        return stocksByPage[page] ?? []
    }

    func setStocks(_ stocks: [StockQuote], forPage page: Int) {
        stocksByPage[page] = stocks
    }
}
