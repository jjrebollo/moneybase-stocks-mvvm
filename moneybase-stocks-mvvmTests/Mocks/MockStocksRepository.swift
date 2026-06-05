//
//  MockStocksRepository.swift
//  moneybase-stocks-mvvmTests
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Foundation
@testable import moneybase_stocks_mvvm

actor MockStocksRepository: StocksRepository {
    var stocksByPage: [Int: [StockQuote]]
    var profilesBySymbol: [String: StockProfile]

    var stocksError: Error?
    var profileError: Error?

    private(set) var requestedPages: [Int] = []
    private(set) var requestedSymbols: [String] = []

    init(
        stocksByPage: [Int: [StockQuote]] = [:],
        profilesBySymbol: [String: StockProfile] = [:],
        stocksError: Error? = nil,
        profileError: Error? = nil
    ) {
        self.stocksByPage = stocksByPage
        self.profilesBySymbol = profilesBySymbol
        self.stocksError = stocksError
        self.profileError = profileError
    }

    func fetchStocks(page: Int) async throws -> [StockQuote] {
        requestedPages.append(page)

        if let stocksError {
            throw stocksError
        }

        return stocksByPage[page] ?? []
    }

    func setStocks(_ stocks: [StockQuote], forPage page: Int) {
        stocksByPage[page] = stocks
    }

    func fetchStockProfile(symbol: String) async throws -> StockProfile {
        requestedSymbols.append(symbol)

        if let profileError {
            throw profileError
        }

        guard let profile = profilesBySymbol[symbol] else {
            throw StocksError.stockNotFound(symbol)
        }

        return profile
    }

    func setProfile(_ profile: StockProfile, forSymbol symbol: String) {
        profilesBySymbol[symbol] = profile
    }
}
