//
//  FetchStocksUseCase.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import Foundation

protocol FetchStocksUseCaseProtocol: Sendable, BaseUseCaseProtocol<Void, [StockQuote]> {
    func handle(input: Void?) async throws -> [StockQuote]
}

final class FetchStocksUseCase: FetchStocksUseCaseProtocol {
    
    private let repository: StocksRepository

    init(repository: StocksRepository) {
        self.repository = repository
    }
    
    func handle(input: ()?) async throws -> Array<StockQuote> {
        try await repository.fetchStocks()
    }
}
