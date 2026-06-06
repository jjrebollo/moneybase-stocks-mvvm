//
//  FetchStocksUseCase.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import Foundation

protocol FetchStocksUseCaseProtocol: Sendable, BaseUseCaseProtocol<Int, [StockQuote]> {
    func handle(input: Int?) async throws -> [StockQuote]
}

nonisolated final class FetchStocksUseCase: FetchStocksUseCaseProtocol {
    
    private let repository: StocksRepository

    init(repository: StocksRepository) {
        self.repository = repository
    }
    
    func handle(input: Int?) async throws -> Array<StockQuote> {
        try await repository.fetchStocks(page: input ?? 1)
    }
}
