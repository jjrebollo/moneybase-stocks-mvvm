//
//  FetchStockProfileUseCase.swift
//  moneybase-stocks-mvvm
//
//  Created by Juan Jose Rebollo on 04/06/2026.
//

import Foundation

protocol FetchStockProfileUseCaseProtocol: Sendable, BaseUseCaseProtocol<String, StockProfile> {
    func handle(input: String?) async throws -> StockProfile
}

nonisolated final class FetchStockProfileUseCase: FetchStockProfileUseCaseProtocol {
    private let repository: StocksRepository

    init(repository: StocksRepository) {
        self.repository = repository
    }

    func handle(input: String?) async throws -> StockProfile {
        guard let input else {
            fatalError("No input provided")
        }
        
        return try await repository.fetchStockProfile(symbol: input)
    }
}
