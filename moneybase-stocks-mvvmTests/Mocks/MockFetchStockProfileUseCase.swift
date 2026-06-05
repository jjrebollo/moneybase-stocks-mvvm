//
//  MockFetchStockProfileUseCase.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 05/06/2026.
//

import Foundation
@testable import moneybase_stocks_mvvm

nonisolated final class MockFetchStockProfileUseCase: @unchecked Sendable, FetchStockProfileUseCaseProtocol {
    var profilesBySymbol: [String: StockProfile]
    var error: Error?

    private(set) var requestedSymbols: [String] = []

    init(profilesBySymbol: [String: StockProfile] = [:], error: Error? = nil) {
        self.profilesBySymbol = profilesBySymbol
        self.error = error
    }

    func handle(input: String?) async throws -> StockProfile {
        guard let symbol = input else {
            fatalError("No input provided")
        }

        requestedSymbols.append(symbol)

        if let error {
            throw error
        }

        guard let profile = profilesBySymbol[symbol] else {
            throw StocksError.stockNotFound(symbol)
        }

        return profile
    }
}
